class SearchController < ApplicationController
  include ListingsHelper
  # Get search results for a search query
  # Listings are stored in array @listings
  # 1 roommate listings, 2 roommate listings, 3 roommates, more
  def results
    # Get the paramters
    @date = params[:date]
    @month = params[:date]["month"].to_i
    @year = params[:date]["year"].to_i
    @lease_length = params[:lease_length].to_i
    @roommates = params[:roommates].to_i if params[:roommates]

    @start_date = start_date(@month, @year)
    @end_date = end_date(@start_date, @lease_length)

    @max_price_1 = params[:max].to_i * 2
    @max_price_2 = params[:max].to_i * 3
    @max_price_3 = params[:max].to_i * 4

    @coordinates = Geocoder.coordinates(params[:location])

    # How to handle availability
    # Store available start and end dates (for more complex handling only store unavailable dates)
    # In query check if start date is greater or equal to and end is less than or equal to

    # Search Listings
    # .where(['available_start >= ? AND available_end <= ?', @start_date, @end_date])
    @listings = Listing.near("Pittsburgh, PA")
    @listings_1 = Listing.near(params[:location])
    @listings_2 = Listing.near(params[:location])
    @listings_3 = Listing.near(params[:location])
    @listings_more = Listing.near(params[:location])
  end

end
