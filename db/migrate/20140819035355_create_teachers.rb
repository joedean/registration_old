class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.references :company, index: true, null: false
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :mobile_phone
      t.string :email
      t.date   :start_date
      t.date   :end_date
      t.date   :birth_date
      t.boolean :active, null: false, default: true
      t.boolean :contractor, null: false, default: false

      t.timestamps
    end
    add_foreign_key :teachers, :companies
    add_foreign_key :teachers, :users
  end
end
