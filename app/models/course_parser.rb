class CourseParser < Parser
  def parse_model
    @model = Course.new
    parse_course line["Class"]
    parse_age line["Age"]
    parse_day_and_time line["Day and Time"]
    parse_studio line["Studio"]
  end

  def parse_course(course)
    @model.name = course.strip
    @model.category = parse_category @model.name
    @model.level = parse_level @model.name
  end

  def parse_age age
    return unless age
    age.strip!
    ages = /^(\d\d?) ?- ?(\d\d?) ?.*/.match(age)
    if ages
      @model.start_age = ages[1]
      @model.end_age = ages[2]
    else
      if age.downcase.include? "teen"
        @model.start_age = 13
      elsif age.downcase.include? "adult"
        @model.start_age = 18
      elsif age.downcase.include? "and up"
        @model.start_age = age.split(' ').first
      else
        Rails.logger.info("No age requirement")
      end
    end
  end

  def parse_day_and_time day_time
    day_time.strip!
    time_data = /^(\w*) (\d\d?:\d\d) - (\d\d?:\d\d)$/.match(day_time)
    return unless time_data
    @model.wday = day_as_int(time_data[1])
    @model.start_at = parse_time(time_data[2])
    @model.end_at = parse_time(time_data[3])
  end

  def day_as_int day_name
    Date::DAYNAMES.index day_name.strip
  end

  def parse_time time
    period = "pm"
    hour = hour time
    period = "am" if @model.wday == 6 &&  hour < 12 && hour > 8
    DateTime.strptime("2001-01-#{@model.wday} #{time} #{period}", "%Y-%m-%d %l:%M %P")
  end

  def parse_studio studio
    @model.studio = studio.strip
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

  private

  def hour time
    time.split(":")[0].to_i
  end
end
