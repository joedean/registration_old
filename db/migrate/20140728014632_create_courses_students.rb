class CreateCoursesStudents < ActiveRecord::Migration
  def change
    create_table :courses_students, id: false do |t|
      t.integer :course_id
      t.integer :student_id

      t.timestamps
    end
    add_foreign_key(:courses_students, :courses)
    add_foreign_key(:courses_students, :students)
 end
end
