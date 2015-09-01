class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.date       :start_date
      t.date       :end_date
      t.integer    :lease_length
      t.integer    :size

      t.boolean    :ready_to_land,  default: false
      t.boolean    :approved,       default: false
      t.boolean    :landed,         default: false

      t.belongs_to :listing,      index: true
      t.references :crew_admin,   index: true

      t.timestamps null: false
    end
  end
end
