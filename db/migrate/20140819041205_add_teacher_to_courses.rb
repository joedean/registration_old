class AddTeacherToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :teacher_id, :integer
    add_foreign_key :courses, :teachers
  end
end
