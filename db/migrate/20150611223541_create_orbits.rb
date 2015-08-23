class CreateOrbits < ActiveRecord::Migration
  def change
    create_table :orbits do |t|
      t.belongs_to :listing, index: true
      t.belongs_to :user, index: true

      t.date :start_date
      t.date :end_date
      t.boolean :has_crew
      
      t.timestamps null: false
    end
    add_index :orbits, [:user_id, :listing_id], unique: true
  end
end
