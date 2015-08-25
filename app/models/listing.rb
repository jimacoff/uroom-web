class Listing < ActiveRecord::Base
  geocoded_by :full_address
  after_validation :geocode

  has_many :crews
  has_many :orbits
  has_many :users, through: :orbits
  belongs_to :owner, class_name: "User"

  def full_address
    address_array = [address, address_2, city, state, zipcode, country].reject(&:blank?)
    address_array.compact.join(', ')
  end

end
