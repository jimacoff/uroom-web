class SearchController < ApplicationController

  # Get search results for a search query
  # Listings are stored in array @listings
  # 1 roommate listings, 2 roommate listings, 3 roommates, more
  def results
    # Get the paramters
    @date = params[:date]
    @month = params[:date]["month"].to_i
    @year = params[:date]["year"].to_i
    @lease_length = params[:lease_length].to_i
    @roommates = params[:roommates].to_i

    @min_price_1 = params[:min].to_i * 2
    @max_price_1 = params[:max].to_i * 2

    @min_price_2 = params[:min].to_i * 3
    @max_price_2 = params[:max].to_i * 3

    @min_price_3 = params[:min].to_i * 4
    @max_price_3 = params[:max].to_i * 4

    # Search Listings
    @listings = Listing.near(params[:location])
    @listings_1 = Listing.near(params[:location])
    @listings_2 = Listing.near(params[:location])
    @listings_3 = Listing.near(params[:location])
    @listings_more = Listing.near(params[:location])
  end

end
