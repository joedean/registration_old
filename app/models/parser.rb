require 'csv'

class Parser

  attr_accessor :course

  def initialize(company_name, file_name)
    @company_name = company_name
    @file_name = file_name
  end

  def execute
    parse_file
  end

  def create_course
    puts @course.inspect
    @course.company = Company.where(name: @company_name).first
    @course.save!
  end

  def parse_file
    CSV.foreach(@file_name, headers: true) do |line|
      @course = Course.new
      parse_course line["Class"]
      parse_age line["Age"]
      parse_day_and_time line["Day and Time"]
      parse_studio line["Studio"]
      create_course
    end
  end

  def parse_course(course)
    @course.name = course.strip
    @course.category = parse_category @course.name
    @course.level = parse_level @course.name
  end

  def parse_age age
    return unless age
    age.strip!
    ages = /^(\d\d?) ?- ?(\d\d?) ?.*/.match(age)
    if ages
      @course.start_age = ages[1]
      @course.end_age = ages[2]
    else
      if age.downcase.include? "teen"
        @course.start_age = 13
      elsif age.downcase.include? "adult"
        @course.start_age = 18
      elsif age.downcase.include? "and up"
        @course.start_age = age.split(' ').first
      else
        Rails.logger.info("No age requirement")
      end
    end
  end

  def parse_day_and_time day_time
    day_time.strip!
    time_data = /^(\w*) (\d\d?:\d\d) - (\d\d?:\d\d)$/.match(day_time)
    return unless time_data
    @course.wday = day_as_int(time_data[1])
    @course.start_at = parse_time(time_data[2])
    @course.end_at = parse_time(time_data[3])
  end

  def day_as_int day_name
    Date::DAYNAMES.index day_name.strip
  end

  def parse_time time
    DateTime.strptime("2000-01-01 #{time} pm", "%Y-%m-%d %l:%M %P")
  end

  def parse_studio studio
    @course.studio = studio.strip
  end

  def parse_category course_name
    name = course_name.downcase.strip
    if name.include?("ballet") || name.include?("pointe") || name.include?("barre")
      "Ballet"
    elsif name.include? "tap"
      "Tap"
    elsif name.include? "jazz"
      "Jazz"
    elsif name.include? "hip hop"
      "Hip Hop"
    elsif name.include? "modern"
      "Modern"
    elsif name.include? "acro"
      "Acro"
    elsif name.include? "pilates"
      "Pilates"
    elsif name.include? "zumba"
      "Zumba"
    elsif name.include? "lyrical"
      "Lyrical"
    elsif name.include? "pure dance"
      "Pure Dance"
    else
      Rails.logger.info "No course catalog can be determined."
      nil
    end
  end

  def parse_level course_name
    name = course_name.strip

    course_data = /^.*\s(I\S* ?(?:Prep)?).*/.match(name)
    level = course_data[1] if course_data

    name.downcase!
    if name.include?("pre") || name.include?("begin")
      level ||= "Beginner"
    elsif name.include? "adult"
      level ||=  "Adult"
    elsif name.include? "int"
      level ||= "Intermediate"
    elsif name.include? "adv"
      level ||= "advanced"
    else
      Rails.logger.info "No level can be determined."
    end
    level
  end
end
