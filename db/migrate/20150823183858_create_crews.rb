class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.date :start_date
      t.date :end_date
      t.integer :size
      t.belongs_to :listing, index: true
      t.timestamps null: false
    end
  end
end
