class AddDateToPlanets < ActiveRecord::Migration
  def change
    add_column :planets, :start_date, :date, null: false
    add_column :planets, :end_date, :date, null: false
  end
end
