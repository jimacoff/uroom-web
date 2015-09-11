class CreatePictures < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.belongs_to :gallery, index: true
      t.attachment :image
      t.timestamps null: false
    end
  end

  def down
    drop_table :pictures
  end
end
