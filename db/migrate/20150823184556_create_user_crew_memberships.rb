class CreateUserCrewMemberships < ActiveRecord::Migration
  def change
    create_table :user_crew_memberships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :crew, index: true
      t.timestamps null: false
    end
  end
end
