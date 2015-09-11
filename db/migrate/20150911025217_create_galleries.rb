class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.belongs_to :listing,  index: true
      t.timestamps null: false
    end
  end
end
