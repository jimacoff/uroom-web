class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.belongs_to :crew,     null: false
      t.belongs_to :listing,  null: false

      t.boolean    :accepted, default: false
      t.boolean    :rejected, default: false
      t.timestamps null: false
    end
  end
end
