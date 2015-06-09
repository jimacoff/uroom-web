class SearchController < ApplicationController

  require 'mechanize'

  AirbnbListing = Struct.new(:title, :price, :id, :url_with_date, :images, :latitude, :longitude)

  def results
    # Get the paramters
    @location = airbnb_location()
    @month = params[:date]["month"].to_i
    @year = params[:date]["year"].to_i
    @lease_length = params[:lease_length].to_i
    @roommates = params[:roommates].to_i
    @people = @roommates + 1
    @min_price = params[:min].to_i * @people
    @max_price = params[:max].to_i * @people

    @page_number = params[:page] ? params[:page] : 1

    @listings = []
    # Search Listing
    # Search Airbnb
    search_airbnb().each do |listing|
      @listings << listing
    end
  end

  private
    def search_airbnb
      agent = Mechanize.new
      checkin = airbnb_checkin()
      checkout = airbnb_checkout()
      page = agent.get("https://www.airbnb.com/s/#{@location}?checkin=#{checkin}%2F01%2F#{@year}&checkout=#{checkout}%2F01%2F#{@checkout_year}&guests=#{@people}&room_types%5B%5D=Entire+home%2Fapt&price_min=#{@min_price}&price_max=#{@max_price}?sublets=monthly")

      airbnb_listings  = []

      all_results = page.search(".listing")
      all_results.each do |result|

        listing = AirbnbListing.new

        listing.title = result.at("@data-name").text.strip
        listing.price = airbnb_format_price(result.at("@data-price").text)
        listing.id = result.at("@data-id").text.strip
        listing.url_with_date = result.at("@data-url").text.strip
        listing.images = result.at("//img[@itemprop = 'image']/@data-urls").text.slice(2...-2).split("\", \"")
        listing.latitude = result.at("@data-lat").text.strip
        listing.longitude = result.at("@data-lng").text.strip

        airbnb_listings << listing
      end
      return airbnb_listings

    end

    def airbnb_checkin
      if @month < 10
        return "0#{@month}"
      else
        return @month
      end
    end

    def airbnb_checkout
      month = (@month + @lease_length) % 12

      if @month + @lease_length > 12
        @checkout_year = @year + 1
      else
        @checkout_year = @year
      end

      if @month < 10
        return "0#{month}"
      else
        return "#{month}"
      end
    end

    def airbnb_location()
      location = params[:location]
      loc_commas = location.gsub!(", ", "--")
      if loc_commas
        loc_spaces = loc_commas.gsub!(" ", "-")
        if loc_spaces
          location = loc_spaces
        else
          location = loc_commas
        end
      else
        loc_spaces = location.gsub!(" ", "-")
        location = loc_spaces if loc_spaces
      end
      return location
    end

    def airbnb_format_price(price)
      ActionController::Base.helpers.sanitize(price).scan(/\d/).join('')
    end
end
