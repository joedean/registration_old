class Student < ActiveRecord::Base
  has_and_belongs_to_many :courses
  has_many :addresses

  belongs_to :family
  belongs_to :user

  def self.list(params)
    if params[:course_id]
      result = eager_load(:courses).where("courses.id = ?", params[:course_id].to_i)
    else
      result = all
    end
    result.order(:id)
  end

  def name
    first_name + " " + last_name
  end

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end

  def available_courses
    Course.all
  end
end
