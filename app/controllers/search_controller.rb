class SearchController < ApplicationController
  include ListingsHelper
  # Get search results for a search query
  # Listings are stored in array @listings
  # 1 roommate listings, 2 roommate listings, 3 roommates, more
  def results
    # Get the paramters

    @lease_length = params[:lease_length].to_i > 0 ? params[:lease_length].to_i : 3
    @roommates = params[:roommates].to_i if params[:roommates]

    @start_date = params[:date].to_date
    @end_date = end_date(@start_date, @lease_length)



    @locations = ["San Francisco, CA", "Foster City, CA", "New York City, NY", "Pittsburgh, PA"]
    @location = @locations[params[:location].to_i]
    @coordinates = Geocoder.coordinates(@location)

    @date = Date.today.at_beginning_of_month.next_month
    @months = []
    (0..11).each do |m|
      @months << [@date.next_month(m).strftime("%b %Y"), @date.next_month(m)]
    end

    # How to handle availability
    # Store available start and end dates (for more complex handling only store unavailable dates)
    # In query check if start date is greater or equal to and end is less than or equal to

    @max_price_1 = params[:max].to_f * 2
    @max_price_2 = params[:max].to_f * 3
    @max_price_3 = params[:max].to_f * 4
    # Search Listings
    # .where(['start_date >= ? AND end_date <= ?', @start_date, @end_date])
    max_results = 10
    if params[:roommates]
      @tenants = params[:roommates].to_i + 1
      @max_price = params[:max].to_i * @tenants
      @listings   =     Listing.near(@location).where('start_date <= ? AND end_date >= ?', @start_date, @end_date)
                                .where('price <= ?', @max_price).where('accommodates >= ?', @tenants)
    else
      @listings   =     Listing.near(@location).where('start_date <= ? AND end_date >= ?', @start_date, @end_date)
      @listings_1 =     @listings.where('price <= ?', @max_price_1).where('accommodates >= ?', 2).limit(max_results)
      @listings_2 =     @listings.where('price <= ? AND price > ?', @max_price_2, @max_price_1).where('accommodates >= ?', 3).limit(max_results)
      @listings_3 =     @listings.where('price <= ? AND price > ?', @max_price_3, @max_price_2).where('accommodates >= ?', 4).limit(max_results)
      @listings_more =  @listings.where('price > ?', @max_price_3).where('accommodates > ?', 4).limit(max_results)
    end
  end

end
