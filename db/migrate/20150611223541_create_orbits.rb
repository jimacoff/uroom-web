class CreateOrbits < ActiveRecord::Migration
  def change
    create_table :orbits do |t|
      t.belongs_to :listing,            index: true
      t.belongs_to :user,               index: true
      t.belongs_to :crew,               index: true

      t.date :start_date,               index: true
      t.date :end_date,                 index: true
      t.integer :number_of_roommates,   index: true

      t.boolean :has_crew,            default: false, index: true
      t.boolean :ready_to_land,       default: false
      t.boolean :landed,              default: false

      t.timestamps                       null: false
    end
    add_index :orbits, [:user_id, :listing_id], unique: true
  end
end
