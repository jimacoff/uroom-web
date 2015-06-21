class CreateOrbits < ActiveRecord::Migration
  def change
    create_table :orbits do |t|
      t.belongs_to :planet, index: true
      t.belongs_to :user, index: true
      t.belongs_to :crew, index: true
      t.timestamps null: false
    end
  end
end
