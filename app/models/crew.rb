class Crew < ActiveRecord::Base
  belongs_to :listing
  belongs_to :crew_admin, class_name: "User"
  has_one    :crew_approval_request

  has_many :crew_requests
  has_many :user_crew_memberships
  has_many :users, through: :user_crew_memberships
end
