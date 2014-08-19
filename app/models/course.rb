class Course < ActiveRecord::Base
  has_and_belongs_to_many :students

  belongs_to :company
  belongs_to :teacher

  STUDIOS = ["A", "B", "C", "D"]
  CATEGORIES = ["Acro", "Ballet", "Hip Hop", "Jazz", "Modern", "Pilates", "Pure Dance", "Tap", "Zumba"]

  def self.studio studio
    where(studio: studio)
  end

  def self.list(params)
    if params[:student_id]
      result = eager_load(:students).where("students.id = ?", params[:student_id].to_i)
    else
      result = all
    end
    result = result.studio params[:studio] unless params[:studio].blank?
    result.order(:id)
  end

  def day
    Date::DAYNAMES[self[:wday]] if self[:wday]
  end

  def full?
    return false unless max_size
    max_size <= students.count
  end

  def duration
    (end_at - start_at)/1.hour
  end
end
