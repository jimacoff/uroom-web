class CreateCrewApprovalRequests < ActiveRecord::Migration
  def change
    create_table :crew_approval_requests do |t|
      t.belongs_to  :crew,     null: false, index: true
      t.belongs_to  :listing,  null: false, index: true
      t.references  :landlord, null: false, index: true
      t.boolean     :accepted, default: false
      t.boolean     :rejected, default: false
      t.timestamps             null: false
    end
  end
end
