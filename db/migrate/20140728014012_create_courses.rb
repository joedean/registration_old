class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :company, index: true, null: false
      t.string :category
      t.string :name
      t.string :level
      t.integer :start_age
      t.integer :end_age
      t.integer :wday
      t.datetime :start_at
      t.datetime :end_at
      t.string :studio
      t.integer :max_size

      t.timestamps
    end
  end
end
