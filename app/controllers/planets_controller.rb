class PlanetsController < ApplicationController

  def show
    # show other users and your crew
  end

  def land
    # Request booking (needs crew id)
  end

  def orbit
    # create if needed
    # else add it to user-planet join table
    @month = params[:month].to_i
    @year = params[:year].to_i
    @lease_length = params[:lease_length].to_i
    @start_date = start_date()
    @end_date = end_date()
    @listing = Listing.find_by(listing_id: params[:id].to_i)
    @planet = Planet.where(listing: @listing)
                    .where(start_date: @start_date)
                    .where(end_date: @end_date).take

    if @planet.nil?
      @planet = Planet.new
      @planet.listing = @listing
      @planet.start_date = @start_date
      @planet.end_date = @end_date
      @planet.save
    end

    # Add to user
    user.planets << @planet
    orbit = Orbit.where("user_id = ? OR planet_id = ?", user.id, @planet.id)
    # Get orbit by Orbit.where(user & planet)

    # redirect_to
    redirect_to(:controller => "listing", :action => "show")
    # pass additional parameters
  end

  private
    def start_date()
      # :year, :month, :day
      @start_date = Date.new(@year, @month, 1)
      return @start_date
    end

    def end_date()
      @end_date = @start_date + @lease_length.months
      return @end_date
    end
end
