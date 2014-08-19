class Teacher < ActiveRecord::Base
  belongs_to :company
  has_many :courses

  def work_hours
    courses.map { |c| c.duration }.sum
  end

  def payroll_hours
    work_hours * 2
  end

  def total_payroll_hours
    payroll_hours
  end
end
