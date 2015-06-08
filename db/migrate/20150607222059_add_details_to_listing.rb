class AddDetailsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :description, :string
    add_column :listings, :location, :string
    add_column :listings, :bedrooms, :integer
    add_column :listings, :bathrooms, :integer
  end
end
