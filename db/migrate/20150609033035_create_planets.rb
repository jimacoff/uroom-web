class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      # Has many users
      # Has many crews (groups)
      t.belongs_to :listing, index: true, null: false
      t.date :start_date, null: false
      t.date :end_date, null:false

      t.timestamps null: false

    end
  end
end
