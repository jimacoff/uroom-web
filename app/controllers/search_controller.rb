class SearchController < ApplicationController
  include ListingsHelper
  # Get search results for a search query
  # Listings are stored in array @listings
  # 1 roommate listings, 2 roommate listings, 3 roommates, more
  def results
    # Get the paramters

    @lease_length = params[:lease_length].to_i
    @roommates = params[:roommates].to_i if params[:roommates]

    @start_date = params[:date].to_date
    @end_date = end_date(@start_date, @lease_length)

    @max_price_1 = params[:max].to_i * 2
    @max_price_2 = params[:max].to_i * 3
    @max_price_3 = params[:max].to_i * 4

    @locations = ["San Francisco, CA", "Foster City, CA", "New York City, NY", "Pittsburgh, PA"]
    @location = @locations[params[:location].to_i]
    @coordinates = Geocoder.coordinates(@location)

    # How to handle availability
    # Store available start and end dates (for more complex handling only store unavailable dates)
    # In query check if start date is greater or equal to and end is less than or equal to

    # Search Listings
    # .where(['start_date >= ? AND end_date <= ?', @start_date, @end_date])
    @listings   =     Listing.near(@location).where(['start_date >= ? AND end_date <= ?'], @start_date, @end_date)
    @listings_1 =     Listing.near(@location).where(['start_date >= ? AND end_date <= ? AND price <= ?'], @start_date, @end_date, @max_price_1)
    @listings_2 =     Listing.near(@location).where(['start_date >= ? AND end_date <= ? AND price <= ?'], @start_date, @end_date, @max_price_2)
    @listings_3 =     Listing.near(@location).where(['start_date >= ? AND end_date <= ? AND price <= ?'], @start_date, @end_date, @max_price_3)
    @listings_more =  Listing.near(@location).where(['start_date >= ? AND end_date <= ? AND price >= ?'], @start_date, @end_date, @max_price_3)
    debugger
  end

end
