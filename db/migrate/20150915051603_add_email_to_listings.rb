class AddEmailToListings < ActiveRecord::Migration
  def change
    add_column :listings, :email, :text
  end
end
