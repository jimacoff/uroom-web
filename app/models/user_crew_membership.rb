class UserCrewMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :crew
end
