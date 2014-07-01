class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :web_site
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
