class Orbit < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  belongs_to :crew
  validates :listing_id, uniqueness: { scope: :user_id }
end
