class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :title
      t.references :owner, index: true

      t.decimal :price
      t.decimal :security_deposit
      t.boolean :active, index: true, default: false

      t.string :description
      t.string :policy

      t.integer :accommodates
      t.integer :bedrooms
      t.float :bathrooms

      t.string :images,    array: true, default: []
      t.string :amenities, array: true, defaults: []

      # Address
      t.text :address, default: ""
      t.text :address_2, default: ""
      t.text :city
      t.text :state
      t.integer :zipcode
      t.text :country

      # Geocoding Information
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
