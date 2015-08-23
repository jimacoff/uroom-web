class Orbit < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  validates :listing_id, uniqueness: { scope: :user_id }
  # belongs_to :crew
end
