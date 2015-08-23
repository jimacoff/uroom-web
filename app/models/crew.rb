class Crew < ActiveRecord::Base
  belongs_to :listing
  has_many :crew_requests
  has_many :user_crew_memberships
  has_many :users, through :user_crew_memberships
end
