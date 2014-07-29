class Course < ActiveRecord::Base
  has_and_belongs_to_many :students

  belongs_to :company

  def day
    Date::DAYNAMES[self[:wday]] if self[:wday]
  end

end
