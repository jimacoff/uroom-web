class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.belongs_to :orbit
      t.timestamps null: false
    end
  end
end
