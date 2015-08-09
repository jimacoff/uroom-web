class PlanetsController < ApplicationController

# Show other users and your crew (if applicabile) for a planet
# Used as an ajax partial
# Could possibly move methods to model
  def show
    # show other users and your crew
    # should be ajax partial
    @planet = Planet.find(params[:id])
    @users = @planet.users
    orbit = @planet.orbits.find_by(user: current_user)
    @crew = orbit.crew
  end


# Landing l
  def land
    # Request booking (needs crew id)
    # Each user

    #
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
    # This should add user to planets and create the orbit

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
