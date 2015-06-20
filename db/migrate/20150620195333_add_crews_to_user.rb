class AddCrewsToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.belongs_to :crew, index: true
    end
  end

  def down
    change_table :users do |t|
      t.remove :crew_id
    end
  end
end
