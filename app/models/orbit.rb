class Orbit < ActiveRecord::Base
  belongs_to :planet
  belongs_to :user
  has_one :crew
end
