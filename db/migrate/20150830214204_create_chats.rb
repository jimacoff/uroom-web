class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.belongs_to :crew,   index: true
      t.boolean    :includes_landlord, default: false
      t.timestamps null: false
    end
  end
end
