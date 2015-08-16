class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|

      t.timestamps null: false
    end
  end
end
