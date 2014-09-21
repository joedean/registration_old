class TeacherParser < Parser
  def parse_model
    @model = Teacher.new
    @model.first_name = parse_first_name
    @model.last_name = parse_last_name
    @model.mobile_phone = parse_mobile_phone
    @model.email = parse_email
    @model.start_date = parse_start_date
    @model.birth_date = parse_birth_date
    @model.active = true
    @model.contractor = false
  end


end
