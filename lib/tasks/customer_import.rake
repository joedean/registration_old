require 'csv'

namespace :customer_import do
  desc "Import student and parent data from a quickbooks customer export to csv"
  task import_from_quickbooks_customer_export: :environment do |task, args|
    company = Company.where(name: "SBDC").first
    CSV.foreach('sbdc_customers.csv', headers: true) do |line|

      home_phone, mother_first_name, guardian_last_name, student_mobile_phone = nil
      birth_date_by_student = {}

      ##### Customer
      names = line["Customer"].split(',')
      # family_name #############
      family_name = names[0].strip
      # student_first_names ############
      student_first_names = []
      names.each do |name|
        next if name.blank?
        next if name == family_name
        if name.include? '&'
          split_names = name.split('&')
          student_first_names << split_names[0].strip
          student_first_names << split_names[1].strip
        else
          student_first_names << name.strip
        end
      end

      ##### Primary Contact
      ##### Bill to 1
      primary_contact, bill_to = nil
      primary_contact = line["Primary Contact"].strip if line["Primary Contact"]
      bill_to = line["Bill to 1"].strip if line["Bill to 1"]
      puts "primary_contact = #{primary_contact}"
      puts "bill_to = #{bill_to}"
      if primary_contact == bill_to
        contact_name = bill_to
      end
      if primary_contact.blank?
        contact_name ||= bill_to
      else
        contact_name ||= primary_contact
      end

      mother, father = nil
      next unless contact_name
      if contact_name.include?('&')
        guardian_names = contact_name.strip.split('&')
        ######### mother_name ###################
        mother = Guardian.new type:"mother"
        mother.first_name = guardian_names[0].strip
        father_names = guardian_names[1].strip.split(' ')
        ######### father_name ###################
        father = Guardian.new type:"father"
        father.first_name = father_names[0].strip
        ######### guardian_last_name ###################
        father.last_name = father_names[1].strip if father_names[1]
        mother.last_name = father.last_name
      else
        guardian_name_hash = parse_guardian_names contact_name
        ######### guardian_first_name ###################
        guardian_first_name = guardian_name_hash[:first_name]
        guardian_middle_name = guardian_name_hash[:middle_name]
        guardian_last_name = guardian_name_hash[:last_name]
      end

      #### Main Email
      ########### guardian_email #############
      guardian_email = line["Main Email"].strip if line["Main Email"]
      #### Main Phone
      if line["Main Phone"]
        guardian_phone_hash = parse_phone_number line["Main Phone"]
        ########### guardian_phone #############
        guardian_phone = guardian_phone_hash[:phone]
        if guardian_phone_hash[:desc] && guardian_phone_hash[:desc].downcase.include?("mom")
          mother ||= Guardian.new type:"mother"
          mother.first_name ||= guardian_first_name
          mother.last_name ||= guardian_last_name
          mother.email = guardian_email
          mother.mobile_phone = guardian_phone
        elsif guardian_phone_hash[:desc].downcase.include?("dad")
          father ||= Guardian.new type:"father"
          father.first_name ||= guardian_first_name
          father.last_name ||= guardian_last_name
          father.email = guardian_email
          father.mobile_phone = guardian_phone
        elsif guardian_phone_hash[:desc].downcase.include?("home")
          home_phone = guardian_phone_hash[:phone]
          mother ||= Guardian.new type:"mother"
          mother.first_name ||= guardian_first_name
          mother.last_name ||= guardian_last_name
          mother.email = guardian_email
        elsif guardian_phone_hash[:desc].downcase.include?("cell")
          if mother
            mother.mobile_phone = guardian_phone_hash[:phone]
          elsif father
            father.mobile_phone = guardian_phone_hash[:phone]
          else
            student_mobile_phone = guardian_phone_hash[:phone]
          end
        elsif (!student_first_names.include? guardian_first_name)
          mother ||= Guardian.new type:"mother"
          mother.first_name ||= guardian_first_name
          mother.last_name ||= guardian_last_name
          mother.email = guardian_email
          mother.mobile_phone = guardian_phone
        else
          puts "Student has no guardian information"
        end
      end

      if line["Work Phone"] && !line["Work Phone"].strip.empty?
        #puts "raw work phone #{line["Work Phone"]}"
        work_phone_hash = parse_phone_number line["Work Phone"]
        #puts "work phone hash = #{work_phone_hash.inspect}"
        if work_phone_hash
          work_phone_names = work_phone_hash[:desc].split(' ')
          if father && father.first_name && work_phone_names[0] && work_phone_names[0].downcase == father.first_name.downcase
            father.work_phone = work_phone_hash[:phone]
          elsif mother && mother.first_name && work_phone_names[0] && work_phone_names[0].downcase == mother.first_name.downcase
            mother.work_phone = work_phone_hash[:phone]
          else
            if father && mother.nil?
              mother = Guardian.new(type: "mother",
                                    first_name: work_phone_names[0],
                                    last_name: work_phone_names[1],
                                    mobile_phone: work_phone_hash[:phone])
              mother.last_name ||= father.last_name
            elsif mother && father.nil?
              father = Guardian.new(type: "father",
                                    first_name: work_phone_names[0],
                                    last_name: work_phone_names[1],
                                    mobile_phone: work_phone_hash[:phone])
              father.last_name ||= mother.last_name
            else
              puts "mother and father are not defined"
            end
          end
        end
      end

      home_phone = line["Home Phone"].strip.tr('-', '') if line["Home Phone"]

      if line["Mobile"]
        mobile_phone_hash = parse_phone_number line["Mobile"]
        mobile_phone_names = mobile_phone_hash[:desc].downcase.split(' ')
        if father && father.first_name && mobile_phone_names[0] == father.first_name.downcase
          father.mobile_phone = mobile_phone_hash[:phone]
        elsif mother
          mother.mobile_phone = mobile_phone_hash[:phone]
        else
          puts "mobile number not matched: #{line["Mobile"]}"
        end
      end

      if line["Fax"]
        fax_phone_hash = parse_phone_number line["Fax"]
        if fax_phone_hash[:desc].include? "cell"
          if fax_phone_hash[:desc].downcase.include? "mom"
            mother ||= Guardian.new type: "mother"
            mother.mobile_phone = fax_phone_hash[:phone]
          elsif fax_phone_hash[:desc].downcase.include? "dad"
            father ||= Guardian.new type: "father"
            father.mobile_phone = fax_phone_hash[:phone]
          else
            mother ||= Guardian.new type: "mother"
            mother.mobile_phone = fax_phone_hash[:phone]
          end
        elsif fax_phone_hash[:desc].include? "home"
          home_phone = fax_phone_hash[:phone]
        end
      end

      birth_dates = [line["birthdates"], line["Bust"], line["Waist"]]

      if student_first_names.size == 1
        birth_date_by_student[student_first_names[0]] = line["birthdates"]
      else
        birth_dates.each do |birth_date|
          next if birth_date.blank?
          birth_date_hash = parse_birth_date birth_date
          #puts "birth_date_hash = #{birth_date_hash.inspect}"
          student_first_names.each do |student_name|
            #puts "student_name = #{student_name.downcase}"
            #puts "bdate_hash_name = #{birth_date_hash[:name].downcase}"
            if student_name && birth_date_hash[:name] && student_name.downcase == birth_date_hash[:name].downcase
              #puts "inside if: setting birth_date_by_student hash to #{birth_date_hash[:birth_date]} for student: #{student_name}"
              birth_date_by_student[student_name] = birth_date_hash[:birth_date]
            end
          end
        end
      end

      puts "########################################################"
      puts "family => name: #{family_name}, company: #{company.id}, home_phone: #{home_phone}"
      f = Family.create name: family_name, company: company, home_phone: home_phone

      if mother
        puts "mother => mother_first_name: #{mother.first_name}, mother_last_name: #{mother.last_name}, mother_mobile_phone: #{mother.mobile_phone}, mother_work_phone: #{mother.work_phone}, mother_email: #{mother.email}"
      f.guardians.create first_name: mother.first_name, last_name: mother.last_name, mobile_phone: mother.mobile_phone, work_phone: mother.work_phone, email: mother.email
      else
        puts "no Mom info"
      end

      if father
        puts "father => father_first_name: #{father.first_name}, father_last_name: #{father.last_name}, father_mobile_phone: #{father.mobile_phone}, father_work_phone: #{father.work_phone}, father_email: #{father.email}"
      f.guardians.create first_name: father.first_name, last_name: father.last_name, mobile_phone: father.mobile_phone, work_phone: father.work_phone, email: father.email
      else
        puts "no Dad info"
      end

      student_first_names.each { |student|
        puts "student => student_first_name: #{student}, student_last_name: #{family_name}, student_birth_date: #{birth_date_by_student[student]}, student_mobile_phone: #{student_mobile_phone}"
        f.students.create first_name: student, last_name: family_name, birth_date: birth_date_by_student[student], mobile_phone: student_mobile_phone
      }

      #family = Family.create(name: family_name, company: company)
      #/(^\D+)(.*)(San Jose|Morgan Hill|Gilroy|Sunnyvale), (CA)\D+(\d+)/.match(line["Bill to"]) { |m|
      #  parent_name = m[1].strip
      #  street_address = m[2].strip
      #  city = m[3].strip
      #  state = m[4].strip
      #  zip_code = m[5].strip
      #  family.addresses.create(kind: "home",
      #                          street_address: street_address,
      #                          city: city,
      #                          state: state,
      #                          zip_code: zip_code)
      #}

      #puts "created #{family.name} family"
    end
  end
end


def parse_phone_number number
  return unless number
  mobile_numbers = /(.*\d{4}) ?(.*)/.match(number.to_s)
  phone_number = mobile_numbers[1].strip.tr('-', '')
  if phone_number.size == 7
    phone_number.insert(0, '408')
  end
  trailing_string = mobile_numbers[2].strip
  { phone: phone_number,
    desc: trailing_string }
end

def parse_guardian_names names, family_name=nil
  guardian_names = names.strip.split(' ')
  if guardian_names.size > 2  && guardian_names[3] == family_name
    middle_name = guardian_names[1].strip
    last_name = guardian_names[2].strip
  else
    middle_name = nil
    last_name = guardian_names[1]
  end
  { first_name: guardian_names[0].strip,
    middle_name: middle_name,
    last_name: last_name }
end

def parse_birth_date birth_date
  puts "birth_date = #{birth_date}"
  birth_dates = /(^.*\/\d\d) ?(.*)/.match(birth_date)
  return {} unless birth_dates
  { birth_date: birth_dates[1],
    name: birth_dates[2] }
end