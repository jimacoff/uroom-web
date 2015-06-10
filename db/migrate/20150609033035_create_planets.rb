class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      # Has many users
      # Has many crews (groups)
      t.belongs_to :listing, index: true, null: false
      t.integer :crew_size, null: false
      t.timestamps null: false

    end
  end
end
