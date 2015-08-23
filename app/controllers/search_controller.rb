class SearchController < ApplicationController

  require 'mechanize'

  AirbnbListing = Struct.new(:title, :price, :id, :url_with_date, :images, :latitude, :longitude)

  # Get search results for a search query
  # Listings are stored in array @listings
  def results
    # Get the paramters
    @month = params[:date]["month"].to_i
    @year = params[:date]["year"].to_i
    @lease_length = params[:lease_length].to_i
    @roommates = params[:roommates].to_i
    @people = @roommates + 1
    @min_price = params[:min].to_i * @people
    @max_price = params[:max].to_i * @people

    # Search Listings
  end

end
