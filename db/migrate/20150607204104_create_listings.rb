class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string      :title,               null: false
      t.references  :owner,              index: true

      t.decimal :price,             precision: 15,      scale: 2,    null: false
      t.decimal :security_deposit,  precision: 15,      scale: 2,    null: false
      t.boolean :active,                index: true,  default: false

      t.string  :description,         default: ""
      t.string  :policy,              default: ""

      t.boolean :furnished,            default: false
      t.integer :accommodates,            null: false
      t.integer :bedrooms,                null: false
      t.float   :bathrooms,               null: false

      t.text :included_appliances,      default: "None"
      t.text :pet_policy,               default: "Allowed"
      t.text :utility_notes,            default: "Not included"
      t.text :parking_notes,            default: "Not included"


      # Address
      t.text    :address,                  null: false
      t.text    :address_2,             default: ""
      t.text    :city,                     null: false
      t.text    :state,                    null: false
      t.integer :zipcode,                  null: false
      t.text    :country

      # Geocoding Information
      t.float :latitude
      t.float :longitude

      t.timestamps                      null: false
    end
  end
end
