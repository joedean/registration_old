require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it { should respond_to(:email) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:start_date) }

  let(:teacher) { Teacher.new }
  let(:course) { create(:course, :start_at => "2001-01-01 13:30:00", :end_at => "2001-01-01 14:30:00") }

  before do
    teacher.courses << [ create(:course, :start_at => "2001-01-01 15:30:00", :end_at => "2001-01-01 16:30:00"),
                         create(:course, :start_at => "2001-01-01 15:30:00", :end_at => "2001-01-01 16:45:00"),
                         create(:course, :start_at => "2001-01-01 15:30:00", :end_at => "2001-01-01 17:00:00") ]
  end

  describe "#work_hours" do
    it "sums course work hours" do
      expect(teacher.work_hours).to eql(3.75)
    end
  end

  describe "#payroll_hours" do
    it "sums payroll hours" do
      expect(teacher.payroll_hours).to eql(7.5)
    end
  end

  describe "#total_payroll_hours" do
    it "sums substitution hours and payroll hours" do
      expect(teacher.total_payroll_hours).to eql(7.5)
    end
  end
end
