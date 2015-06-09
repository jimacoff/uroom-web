class ListingsController < ApplicationController

  def listing
    #show
    # get parameters
    @id = params[:id].to_i
    @people = params[:roommates].to_i + 1
    @month = params[:month].to_i
    @year = params[:year].to_i
    @lease_length = params[:lease_length].to_i
    @airbnb = true

    # If it's an airbnb listing parse airbnb's page
    # Create a Listing object, don't save
    if @airbnb
      # @available is set later
      @available = false
      @listing = parse_airbnb()
    else
      @lising = Listing.find(@id)
    end
  end

  def orbit

  end

  private
    def parse_airbnb()
      listing = Listing.new
      listing.listing_id = @id
      listing.airbnb = true

      agent = Mechanize.new
      checkin = airbnb_checkin
      checkout = airbnb_checkout
      puts "https://www.airbnb.com/rooms/#{@id}?checkin=#{checkin}%2F01%2F#{@year}&checkout=#{checkout}%2F01%2F#{@checkout_year}&guests=#{@people}"
      page = agent.get("https://www.airbnb.com/rooms/#{@id}?checkin=#{checkin}%2F01%2F#{@year}&checkout=#{checkout}%2F01%2F#{@checkout_year}&guests=#{@people}")

      json = agent.get("https://www.airbnb.com/rooms/ajax_refresh_subtotal?utf8=✓&checkin=#{checkin}%2F01%2F#{@year}&checkout=#{checkout}%2F01%2F#{@checkout_year}&number_of_guests=#{@people}&hosting_id=#{@id}").body
      hash = JSON.parse(json)
      @available = hash["available"]

      ##### Longer & Setup Methods #####
      # If available get the price #
      if @available
        listing.price = hash["total_price_native"].to_i
      end
      ##############################

      # Get House Details Column #
      details_column = page.at("//div[@id = 'details-column']")
      ##############################

      #     Gets House Rules      #
      temp_divs = []
      details_column.search(".expandable-content").each do |div|
        temp_divs << div
      end
      rules = temp_divs.last.text
      ##############################

      #         Amenities         #
      amenities_hash = {1 => "TV", 2 => "Cable TV", 3 => "Internet", 4 => "WiFi", 5 => "Air Conditioning", 6 => "Wheelchair accessible", 7 => "Pool", 8 => "Kitchen", 9 => "Free Parking on Premises", 10 => "", 11 => "Smoking", 12 => "Pets Allowed", 13 => "", 14 => "Doorman", 15 => "Gym", 16 => "Breakfast", 17 => "", 18 => "", 19 => "", 20 => "", 21 => "Elevator", 22 => "", 23 => "", 24 => "", 25 => "Hottub", 26 => "", 27 => "Indoor Fireplace", 28 => "Buzzer/Wireless Intercom", 29 => "", 30 => "Heating", 31 => "Family Friendly", 32 => "Suitable for Events", 33 => "Washer", 34 => "Dryer", 35 => "Smoke Detector", 36 => "Carbon Monoxide Detector", 37 => "First Aid Kit", 38 => "Safety Card", 39 => "Fire Extinguisher", 40 => "Essentials", 41 => "Shampoo"}

      metas = []
      page.search("meta").each do |meta|
        metas << meta
      end

      amenities = []
      info_json = JSON.parse(metas[(metas.size - 2)]["content"])
      info_json["airEventData"]["amenities"].each do |n|
        amenities << amenities_hash[n]
      end
      #############################

      #         Images         #
      # First image is header image
      images = []
      images << page.at(".with-photos.with-modal").at("//img").at("@src").text.strip
      info_json["photoData"].each do |data|
        images << data["url"]
      end
      #############################

      #      Home Details         #
      details = []
      page.search(".col-md-9").search(".row")[3].search("strong").each do |detail|
        # [Property Type, Accommodates, Bedrooms, Bathrooms, Beds]
        # [      0     ,        1     ,     2   ,     3    ,  4  ]
        details << detail.text.strip
      end
      #############################

      listing.title = page.title
      #listing.owner_id
      #@listing.summary = details_column.at(".row-space-8.row-space-top-8").at("p")
      listing.location = page.at("@data-location").text.strip
      listing.description = details_column.at(".expandable-content.expandable-content-long").search("p")
      listing.amenities = amenities
      listing.rules = rules
      listing.accommodates = details[1].to_i
      listing.bedrooms = details[2].to_i
      listing.bathrooms = details[3].to_i
      listing.beds = details[4].to_i
      listing.images = images

      return listing
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

    def airbnb_available
      json = @mechanize.get("https://www.airbnb.com/rooms/ajax_refresh_subtotal?utf8=✓&checkin=#{@checkin}&checkout=#{@checkout}&number_of_guests=#{guests}&hosting_id=#{@id}").body
      hash = JSON.parse(json)
      return @available = hash["available"]
    end
end
