class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :name
      t.references :company, index: true
      t.references :user, index: true
      t.references :address, index: true
      t.string :status, default: 'active'
      t.string :emergency_contact_name
      t.string :emergency_contact_phone

      t.timestamps
    end
  end
end
