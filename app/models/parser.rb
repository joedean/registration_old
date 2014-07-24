require 'csv'

class Parser
  attr_accessor :company_name, :file, :family_name, :students,
                :mother, :father, :guardian, :home_phone

  def initialize(company_name, file)
    @company_name = company_name
    @file = file
    @birth_dates = {}
  end

  def execute
    parse file
    create_family
  end

  def parse file
    CSV.foreach(file, headers: true) do |line|
      parse_customer line["Customer"]
      parse_primary_contact line["Primary Contact"]
      parse_bill_to line["Bill to 1"]
      parse_student_birth_date line["birthdates"]
      parse_bust line["Bust"]
      parse_waist line["Waist"]
      parse_main_phone line["Main Phone"]
      parse_home_phone line["Home Phone"]
      parse_work_phone line["Work Phone"]
      parse_mobile line["Mobile"]
      parse_fax line["Fax"]
      parse_2242 line["2242"]
      parse_main_email line["Main Email"]
    end
  end

  def create_family
    company = Company.where(name: @company_name).first
    f = Family.create(name: @family_name, company: company, home_phone: @home_phone)
    if @mother
      f.guardians << @mother
    else
      puts "No Mom Info"
    end
    if @father
      f.guardians <<  @father
    else
      puts "No Dad Info"
    end
    f.students << @students
    f.save!
    puts "Family data saved: #{f.inspect}"
  end

  def parse_main_phone main_phone
    phone_hash = parse_phone_number main_phone
    phone_type = phone_hash[:desc]
    phone = phon_hash[:phone]
    if phone_type == "mother"
      @mother.mobile_phone = phone
    elsif phone_type == "father"
      @father.mobile_phone = phone
    else
      # set first student mobile phone number
    end
  end

  def parse_customer customer
    @family_name = parse_family_name_from_customer customer
    student_first_names = parse_student_first_names_from_customer customer
    @students = []
    student_first_names.each { |first_name|
      @students << Student.new(first_name: first_name, last_name: @family_name)
    }
  end

  def parse_primary_contact primary_contact
    guardians = parse_guardian primary_contact
    @mother = guardians[:mother]
    @father = guardians[:father]
    @guardian = guardians[:guardian]
  end

  def parse_bill_to bill_to
    guardians = parse_guardian bill_to
    @mother ||= guardians[:mother]
    @father ||= guardians[:father]
    @guardian ||= guardians[:guardian]
    if guardians[:mother] && @mother && guardians[:mother] != @mother
      @mother = guardians[:mother]
    end
    if guardians[:father] && @father && guardians[:father] != @father
      @father = guardians[:father]
    end
    if guardians[:guardian] && @guardian && guardians[:guardian] != @guardian
      @guardian = guardians[:guardian]
    end
  end

  def parse_student_birth_date birth_date
    birth_date_hash = parse_birth_date birth_date
    @students.each { |student|
      if birth_date_hash[:name].blank?
        student.birth_date = birth_date_hash[:birth_date]
      else
        if student.first_name == birth_date_hash[:name]
          student.birth_date = birth_date_hash[:birth_date]
        end
      end
    }
  end

  def parse_bust bust
    parse_student_birth_date bust
  end

  def parse_waist waist
    parse_student_birth_date waist
  end

  def parse_birth_date birth_date
    birth_dates = /(^.*\/\d{2}\d{2}?) ?(.*)/.match(birth_date)
    return {} unless birth_dates
    birth_date = birth_dates[1].strip.split('/')
    if birth_date.size != 3
      birth_date = nil
    else
      month = birth_date[0]
      day = birth_date[1]
      year = birth_date[2]
      year = "20"+year if year.size == 2 && year.to_i < 20
      birth_date = Date.new year.to_i, month.to_i, day.to_i
    end
    { birth_date: birth_date,
      name: birth_dates[2] }
  end

  private
  def parse_family_name_from_customer customer
    customer.split(',').shift.strip
  end

  def parse_student_first_names_from_customer customer
    names = customer.split(',')
    names.shift
    student_first_names = []
    names.each do |name|
      if name.include? '&'
        split_names = name.split('&')
        student_first_names << split_names.shift.strip
        student_first_names << split_names.shift.strip
      else
        student_first_names << name.strip
      end
    end
    student_first_names
  end

  def parse_mother_from_primary_contact primary_contact
    return unless primary_contact.include? '&'
    mother = Guardian.new(type: "mother")
    names = primary_contact.strip.split('&')
    mother.first_name = names[0].strip
    other_names = names[1].strip.split(' ')
    other_names.shift
    mother.last_name = other_names.join(" ") unless other_names.empty?
    mother
  end

  def parse_father_from_primary_contact primary_contact
    return unless primary_contact.include? '&'
    father = Guardian.new(type: "father")
    names = primary_contact.strip.split('&')
    other_names = names[1].strip.split(' ')
    father.first_name = other_names.shift
    father.last_name = other_names.join(" ")
    father
  end

  def parse_guardian_from_primary_contact primary_contact
    guardian_names = parse_name primary_contact
    guardian = Guardian.new
    guardian.first_name = guardian_names[:first_name]
    #guardian.middle_name = guardian_names[:middle_name]
    guardian.last_name = guardian_names[:last_name]
    guardian
  end

  def parse_guardian guardian_input
    mother, father, guardian = nil
    if guardian_input.include? '&'
      mother = parse_mother_from_primary_contact guardian_input
      father = parse_father_from_primary_contact guardian_input
    else
      guardian = parse_guardian_from_primary_contact guardian_input
    end
    { mother: mother,
      father: father,
      guardian: guardian }
  end


  def parse_name name
    names = name.strip.split(' ')
    first_name = nil
    middle_name = nil
    last_name = nil
    if names.size > 2
      first_name = names.shift
      if names.join(' ') == @family_name
        last_name = names.join(' ')
      else
        middle_name = names.shift
        last_name = names.join(' ')
      end
    elsif names.size == 2
      first_name = names[0].strip
      last_name = names[1].strip
    else
      last_name = names[0].strip
    end
    { first_name: first_name,
      middle_name: middle_name,
      last_name: last_name }
  end
end
