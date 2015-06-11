class RemoveCrewSizeFromPlanets < ActiveRecord::Migration
  def change
    remove_column :planets, :crew_size, :integer
  end
end
