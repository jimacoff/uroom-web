class Planet < ActiveRecord::Base
  belongs_to :listing
  has_many :orbits
  has_many :users, through: :orbits
end
