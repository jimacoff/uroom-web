class Listing < ActiveRecord::Base
  geocoded_by :full_address
  after_validation :geocode

  has_one  :gallery
  has_many :pictures, through: :gallery
  has_many :crews
  has_many :orbits
  has_many :users, through: :orbits
  belongs_to :owner, class_name: "User"

  accepts_nested_attributes_for :gallery, allow_destroy: true

  def full_address
    address_array = [address, address_2, city, state, zipcode, country].reject(&:blank?)
    address_array.compact.join(', ')
  end

end
