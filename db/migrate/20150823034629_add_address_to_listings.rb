class AddAddressToListings < ActiveRecord::Migration
  def change
    add_column :listings, :address, :text
    add_column :listings, :address_2, :text
    add_column :listings, :city, :text
    add_column :listings, :state, :text
    add_column :listings, :zipcode, :integer
    add_column :listings, :country, :text
  end
end
