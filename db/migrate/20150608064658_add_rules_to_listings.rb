class AddRulesToListings < ActiveRecord::Migration
  def change
    add_column :listings, :rules, :string
    add_column :listings, :accommodates, :integer
  end
end
