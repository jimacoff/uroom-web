class PlanetsController < ApplicationController

  def show
  end

  def orbit
    # create if needed
    # else add it to user-planet join table
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
    # redirect_to
    redirect_to(:controller => "listing", :action => "show")
  end

  private
    def start_date()
      # :year, :month, :day
      @start_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      return @start_date
    end

    def end_date()
      lease_length = params[:lease_length].to_i
      @end_date = @start_date + lease_length.months
      return @end_date
    end
end
