class CreateGuardians < ActiveRecord::Migration
  def change
    create_table :guardians do |t|
      t.string     :first_name
      t.string     :last_name
      t.string     :type
      t.references :family
      t.string     :mobile_phone
      t.string     :work_phone
      t.string     :email
      t.integer    :active

      t.timestamps
    end
  end
end
