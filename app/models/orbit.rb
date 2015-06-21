class Orbit < ActiveRecord::Base
  belongs_to :planet
  belongs_to :user
  belongs_to :crew
end
