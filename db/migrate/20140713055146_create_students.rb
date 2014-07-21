class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :family, index: true, null: false
      t.references :user, index: true
      t.string     :first_name
      t.string     :last_name
      t.references :address, index: true
      t.string     :mobile_phone
      t.string     :email
      t.date       :birth_date
      t.string     :allergies
      t.string     :medical_information
      t.integer    :active, null: false, default: 1

      t.timestamps
    end
  end
end
