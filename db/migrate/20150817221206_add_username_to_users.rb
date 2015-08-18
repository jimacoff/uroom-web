class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :null => false, :unique => true
    add_column :users, :first_name, :string, :null => false
    add_column :users, :last_name, :string, :null => false
  end
end
