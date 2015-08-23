class ListingsController < ApplicationController

  def show

    #show
    # get parameters
    @id = params[:id].to_i
    @people = params[:roommates].to_i + 1
    @month = params[:month].to_i
    @year = params[:year].to_i
    @lease_length = params[:lease_length].to_i

    @listing = Listing.find(@id)
    # Uncomment when user features established
    # check if user has planet for this
    # orbits = []
    # user.orbits.each do |orbit|
    #   if orbit.planet.listing == @listing
    #     orbits << orbit
    #   end
    # end
  end

  def orbit

  end

end
