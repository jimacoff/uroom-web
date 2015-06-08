class AddAirbnbBedsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :beds, :integer
  end
end
