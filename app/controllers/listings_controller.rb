class ListingsController < ApplicationController
  include ListingsHelper
  layout "dashboard", only: [:edit]
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :orbit, :land, :update_date]
  skip_before_action :verify_authenticity_token, only: [:callbacks]


  # If user is signed in & dates are passed
  # => If no crew
  # => # => Show other orbiters
  # => # => If not following, allow following
  # => # => If following
  # => # => # => allow change of dates
  # => # => # => allow unfollow
  # => If has crew
  # => # => show crew options

  # If signed in & NO dates
  # => Prompt dates when following
  # => Show number of orbiters

  # If not signed in
  # => No following
  # => Show number of orbiters

  def show
    # get parameters
    @listing = Listing.find(params[:id])
    @orbit = Orbit.find_by(user: current_user, listing: @listing)
    @follower_count = Orbit.where(listing: @listing).count
    @crew = @orbit.crew if @orbit.present?
    @chat = @crew.chat if @crew
    @message = Message.new
    @new_orbit = Orbit.new

    if params[:date]
      get_params
    else
      if @orbit.present?
        @start_date = @orbit.start_date
        @end_date = @orbit.end_date
        @date = @start_date
        @not_available = !(@start_date >= @listing.start_date && @end_date <= @listing.end_date)
        # calculate lease length
      end
    end

    @followers = @listing.users.references( :orbits ).where( orbits: { start_date: @start_date, end_date: @end_date, has_crew: false }) if @start_date
    @followers = @followers -= [current_user] if @followers

    if @start_date.nil?
      @start_date = @listing.start_date > Date.today.beginning_of_month.next_month ? @listing.start_date : Date.today.beginning_of_month.next_month
    end

    length = (@listing.end_date.year * 12 + @listing.end_date.month) - (@listing.start_date.year * 12 + @listing.start_date.month)

    @months = []
    (0..length).each do |m|
      @months << [@listing.start_date.next_month(m).strftime("%b %Y"), @listing.start_date.next_month(m)]
    end
  end

  def new
    @listing = Listing.new
    @begin_date = Date.today.at_beginning_of_month.next_month
    @start_months = []
    (0..11).each do |m|
      @start_months << [@begin_date.next_month(m).strftime("%b %Y"), @begin_date.next_month(m)]
    end

    @final_date = Date.today.at_beginning_of_month.next_month.next_month
    @end_months = []
    (0..11).each do |m|
      @end_months << [@final_date.next_month(m).strftime("%b %Y"), @final_date.next_month(m)]
    end
  end

  def create
    listing = Listing.new(listing_params)
    listing.owner = current_user
    listing.owner.landlord = true
    gallery = Gallery.create
    if params[:listing][:pictures]
        params[:listing][:pictures].each { |image|
          gallery.pictures.create(image: image)
        }
    end
    listing.active = true
    listing.gallery = gallery
    if listing.save
      current_user.save
      redirect_to listing
    else
      flash[:error] = "Could not create listing."
      render 'new'
    end
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update_attributes(listing_params)
      if params[:listing][:pictures]
          params[:listing][:pictures].each { |image|
            @listing.gallery.pictures.create(image: image)
          }
      end
      redirect_to @listing
    else
      flash[:error] = "Could not update listing."
      render 'edit'
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    redirect_to dashboard_myproperties_path
  end

  # Orbit - user, listing, start_date, end_date, has_crew
  def orbit
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)
    available = (@start_date >= @listing.start_date && @end_date <= @listing.end_date)
    if @user_orbit.nil?
      orbit = Orbit.new(user: current_user,  listing: @listing,
                                      start_date: @start_date,
                                      end_date: @end_date)
      if available && orbit.save
        flash[:success] = "Followed listing"
      else
        flash[:error] = "This listing is not available for those dates"
      end
    else
      flash[:error] = "You've already followed this listing"
    end
    reload_page
  end

  def unorbit
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)
    if @user_orbit.present?
      @user_orbit.destroy
      flash[:alert] = "You've unfollowed this listing"
    end
    reload_page
  end

  def update_date
    get_params
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)
    @user_orbit.start_date = @start_date
    @user_orbit.end_date = @end_date

    available = (@start_date >= @listing.start_date && @end_date <= @listing.end_date)

    if available && @user_orbit.save
      flash[:success] = "Updated follow dates"
    else
      flash[:error] = "This listing is not available for those dates"
    end
    reload_page
  end

  def land
    @listing = Listing.find(params[:id])
    # If crew is approved
    # Set listing to not active
    # Set tenant crew to current Crew
    # Set user's tenant listing to this listing
    # Delete orbit
    # Redirect to lease registration

    # Create Lease Object
    # Create Signatures
  end

  def booking_request
    @listing = Listing.find(params[:id])
    @crew = @listing.crews.find(params[:crew])

    if @crew.crew_admin == current_user
      if BookingRequest.create(crew: @crew, listing: @listing)
        crew.update(requested: true)
        flash[:success] = "Your request has been sent to the owner"
      else
        flash[:error] = "Sorry, we couldn't create your request right now. Try again later."
      end
      redirect_to @listing
    else
      flash[:error] = "Sorry, only the crew admin can do that."
      redirect_to @listing
    end
  end

  private

    def get_params
      @listing = Listing.find(params[:id])
      @roommates = params[:roommates].to_i
      @lease_length = params[:lease_length].to_i
      @date = params[:date].to_date if params[:date]

      if params[:start_date]
        @start_date = params[:start_date].to_date
      else
        @start_date = @date
      end
      @end_date = end_date(@start_date, @lease_length) if @start_date
    end

    def reload_page
      redirect_to action: :show,  id: @listing,
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
                                              :bathrooms,
                                              :start_date,
                                              :end_date,
                                              :security_deposit,
                                              :furnished)
    end

end
