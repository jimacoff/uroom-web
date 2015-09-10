class Orbit < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  belongs_to :crew
  validates :listing_id, uniqueness: { scope: :user_id }

  def lease_length
    (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
  end
end
