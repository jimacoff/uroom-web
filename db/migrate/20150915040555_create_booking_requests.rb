class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.belongs_to :crew,     null: false, index: true
      t.belongs_to :listing,  null: false, index: true

      t.boolean    :accepted, default: false, index: true
      t.boolean    :rejected, default: false, index: true
      t.timestamps null: false
    end
  end
end
