class AddAvailabilityToListings < ActiveRecord::Migration
  def change
    add_column :listings, :start_date, :date, null: false
    add_column :listings, :end_date,   :date
  end
end
