class AddAccomodatesToListings < ActiveRecord::Migration
  def change
    add_column :listings, :accommodates, :integer
  end
end
