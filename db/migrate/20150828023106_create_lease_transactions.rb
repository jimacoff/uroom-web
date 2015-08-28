class CreateLeaseTransactions < ActiveRecord::Migration
  def change
    create_table :lease_transactions do |t|
      # Basic transaction information
      t.string :description,       null: false
      t.decimal :amount,           null: false
      t.date :applicable_date
      t.date :due_date

      # Listing Information
      t.belongs_to :listing,      index: true
      t.text :unit_address,        null: false

      # Tenant Information
      t.belongs_to :user,         index: true
      t.text :tenant_name,         null: false
      t.text :tenant_email,        null: false

      # Landlord Information
      t.references :landlord,     index: true
      t.text :landlord_name,       null: false
      t.text :landlord_email,      null: false

      # Payment Completion Information
      t.boolean :paid,          default: false
      t.text :payment_method
      t.date :paid_date

      # Billing Address
      t.text :street_address
      t.text :locality
      t.text :region
      t.integer :postal_code
      t.timestamps null: false
    end
  end
end
