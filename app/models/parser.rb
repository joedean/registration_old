require 'csv'

class Parser
  attr_accessor :model

  def initialize(company_name, file_name)
    @company_name = company_name
    @file_name = file_name
  end

  def execute
    parse_file
  end

  def create_model
    puts @model.inspect
    @model.company = Company.where(name: @company_name).first
    @model.save!
  end

  def parse_file
    CSV.foreach(@file_name, headers: true) do |line|
      parse_model
      create_model
    end
  end
end
