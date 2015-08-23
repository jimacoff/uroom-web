class Listing < ActiveRecord::Base
  geocoded_by :full_address
  after_validation :geocode

  has_many :crews
  has_many :orbits
  has_many :users, through :orbits

  def full_address
    [address, address_2, state, zipcode, country].compact.join(', ')
  end
end
