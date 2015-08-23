class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :title
      t.integer :listing_id
      t.integer :owner_id
      t.integer :price

      t.string :description
      t.string :address
      t.integer :bedrooms
      t.bathrooms :float
      
      t.timestamps null: false
    end
  end
end
