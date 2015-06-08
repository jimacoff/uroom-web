class AddRulesToListings < ActiveRecord::Migration
  def change
    add_column :listings, :rules, :string
  end
end
