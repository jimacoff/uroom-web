class Crew < ActiveRecord::Base
  has_many :users
  has_many :rejected_users, :class_name => "User"
  has_many :potential_users, :class_name => "User"
  has_many :orbits
end
