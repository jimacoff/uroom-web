class AddArraystoListings < ActiveRecord::Migration
  def change
    add_column :listings, :images, :string, array:true, default: []
    add_column :listings, :amenities, :string, array:true, default: []
  end
end
