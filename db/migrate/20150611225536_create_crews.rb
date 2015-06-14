class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|

      t.timestamps null: false
    end
  end
end
