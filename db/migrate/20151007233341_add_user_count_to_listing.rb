class AddUserCountToListing < ActiveRecord::Migration
  def change
    add_column :listings, :users_count, :integer, default: 0
  end
end
