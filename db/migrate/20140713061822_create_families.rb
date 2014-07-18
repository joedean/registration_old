class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string     :name, null: false
      t.references :company, index: true
      t.references :user, index: true
      t.string     :home_phone
      t.integer    :active, null: false, default: 1
      t.string     :emergency_contact_name
      t.string     :emergency_contact_phone

      t.timestamps
    end
  end
end
