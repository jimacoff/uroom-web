class ListingsController < ApplicationController
  include ListingsHelper
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :orbit, :land, :update_date]

  def new
    @listing = Listing.new
  end

  def create
    listing = Listing.new(listing_params)
    listing.owner = current_user

    if listing.save
      redirect_to listing
    else
      flash[:error] = "Could not create listing."
      render 'new'
    end
  end

  def show
    # get parameters
    if params[:listing]
      get_params
    else
      @listing = Listing.find(params[:id])
    end
    # If user is orbiting show others orbiting

    # Uncomment when user features established
    # check if user has planet for this
    # orbits = []
    # user.orbits.each do |orbit|
    #   if orbit.planet.listing == @listing
    #     orbits << orbit
    #   end
    # end
  end

  def edit
    @listing = Listing.find(params[:id])
  end
  
  def update
    @listing = Listing.find(params[:id])
    if @listing.update_attributes(listing_params)
      redirect_to @listing
    else
      flash[:error] = "Could not update listing."
      render 'edit'
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destory
    # Redirect to dashboard
  end

  # Orbit - user, listing, start_date, end_date, has_crew
  def orbit
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)

    if @user_orbit.nil?
      orbit = Orbit.new(user: @user,  listing: @listing,
                                      start_date: @start_date,
                                      end_date: @end_date)
      if orbit.save
        flash[:success] = "Liked listing"
      else
        flash[:error] = "Could not like listing"
      end
    else
      flash[:error] = "You've already liked this listing"
    end
    reload_page
  end

  def unorbit
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)
    if @user_orbit.present?
      @user_orbit.destroy
      flash[:alert] = "You've unliked this listing"
    end
    reload_page
  end

  def update_date
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)
    @user_orbit.start_date = @start_date
    @user_orbit.end_date = @end_date

    if @user_orbit.save
      flash[:success] = "Updated like dates"
    else
      flash[:error] = "Could not update like dates"
    end
    reload_page
  end

  def land

  end

  private

    def get_params
      @listing = Listing.find(params[:listing])
      @roommates = params[:roommates].to_i
      @lease_length = params[:lease_length].to_i
      @date = params[:date]

      @start_date = start_date(@date[:month].to_i, @date[:year].to_i)
      @end_date = end_date(@start_date, @lease_length)
    end

    def reload_page
      redirect_to action: :show,  listing: @listing,
                                  date: @date,
                                  roommates: @roommates,
                                  lease_length: @lease_length
    end

    def listing_params
      params.require(:listing).permit(:title, :description,
                                              :policy,
                                              :address,
                                              :address_2,
                                              :city,
                                              :state,
                                              :country,
                                              :zipcode,
                                              :price,
                                              :accommodates,
                                              :bedrooms,
                                              :bathrooms)
    end

end
