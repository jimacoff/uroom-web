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
    @cover_photo = @listing.pictures.first
    @images = @listing.pictures.drop(1)
    @orbit = Orbit.find_by(user: current_user, listing: @listing)
    @crew = @orbit.crew if @orbit
    get_params if params[:start_date]
    @has_crew = @crew.present?
    @is_orbitting = @orbit.present?

    if @has_crew
      @chat = @crew.chat
      @has_crew = true
      @message = Message.new
      @start_date = @orbit.start_date
      @end_date = @orbit.end_date
    elsif @is_orbitting
      @crew = Crew.new
      @start_date = @orbit.start_date if (@start_date.nil? || params[:lease_length].to_i <= 0)
      @end_date = @orbit.end_date if (@start_date.nil? || params[:lease_length].to_i <= 0)

      @followers = @listing.users.references( :orbits ).where( orbits: { start_date: @start_date, end_date: @end_date, crew: nil })
      @followers = @followers -= [current_user] if @followers
    else
      @orbit = Orbit.new
      @crew = Crew.new
      @start_date = (@listing.start_date > Date.today.beginning_of_month.next_month ? @listing.start_date : Date.today.beginning_of_month.next_month) if @start_date.nil?
    end

    @selected_users = []
    @not_available = !(@start_date >= @listing.start_date && @end_date <= @listing.end_date) if params[:start_date]

    @months = []
    length = (@listing.end_date.year * 12 + @listing.end_date.month) - (@listing.start_date.year * 12 + @listing.start_date.month)
    (0..length).each do |m|
      @months << [@listing.start_date.next_month(m).strftime("%b %Y"), @listing.start_date.next_month(m)]
    end
  end

  def new
    @listing = Listing.new
    @start_months = start_months
    @end_months = end_months
  end

  def create
    listing = Listing.new(listing_params)
    listing.start_date = Date.new(params[:date][:start_year].to_i, params[:date][:start_month].to_i, 1)
    listing.end_date = Date.new(params[:date][:end_year].to_i, params[:date][:end_month].to_i, 1)
    listing.owner = current_user
    gallery = Gallery.create
    if params[:cover_picture]
      gallery.pictures.create(image: params[:cover_picture])
    else
      gallery.pictures.create()
    end
    if params[:listing][:pictures]
        params[:listing][:pictures].each { |image|
          gallery.pictures.create(image: image)
        }
    end
    listing.active = true
    listing.gallery = gallery
    if listing.save
      current_user.update(landlord: true, regular_user: false)
      redirect_to listing
    else
      flash[:error] = "Could not create listing."
      render 'new'
    end
  end

  def edit
    @listing = Listing.find(params[:id])
    @cover_photo = @listing.pictures.first if @listing.pictures.first && @listing.pictures.first.image
    @images = @listing.pictures.drop(1)
    @start_date = @listing.start_date
    @end_date = @listing.end_date
  end

  def update
    listing = Listing.find(params[:id])
    listing.start_date = Date.new(params[:date][:start_year].to_i, params[:date][:start_month].to_i, 1)
    listing.end_date = Date.new(params[:date][:end_year].to_i, params[:date][:end_month].to_i, 1)
    if listing.update_attributes(listing_params)
      if params[:cover_picture]
        listing.pictures.first.update(image: params[:cover_picture])
      end
      if params[:listing][:pictures]
          params[:listing][:pictures].each { |image|
            listing.gallery.pictures.create(image: image)
          }
      end
      redirect_to listing
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
    redirect_to @listing
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
    available = (@start_date >= @listing.start_date && @end_date <= @listing.end_date)
    @user_orbit = Orbit.find_by(user: current_user, listing: @listing)

    if available && @user_orbit.update_attributes(start_date: @start_date, end_date: @end_date)
      flash[:success] = "Updated follow dates"
    else
      flash[:error] = "This listing is not available for those dates"
    end
    reload_page
  end

  # def land
  #   @listing = Listing.find(params[:id])
  #   # If crew is approved
  #   # Set listing to not active
  #   # Set tenant crew to current Crew
  #   # Set user's tenant listing to this listing
  #   # Delete orbit
  #   # Redirect to lease registration
  #
  #   # Create Lease Object
  #   # Create Signatures
  # end

  def booking_request
    @listing = Listing.find(params[:id])
    @crew = Crew.find(params[:crew])

    if @crew.crew_admin == current_user
      if BookingRequest.create!(crew: @crew, listing: @listing)
        @crew.update(requested: true)
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
      @start_date = params[:start_date].to_date if params[:start_date]
      @lease_length = params[:lease_length].to_i
      @end_date = end_date(@start_date, @lease_length) if @start_date
    end

    def reload_page
      redirect_to action: :show,  id: @listing,
                                  start_date: @start_date,
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
                                              :furnished,
                                              :included_appliances,
                                              :pet_policy,
                                              :utility_notes,
                                              :parking_notes
                                              )
    end

    def start_months
      begin_date = Date.today.at_beginning_of_month.next_month
      months = []
      (0..11).each do |m|
        months << [begin_date.next_month(m).strftime("%b %Y"), begin_date.next_month(m)]
      end
      months
    end

    def end_months
      final_date = Date.today.at_beginning_of_month.next_month.next_month
      months = []
      (0..11).each do |m|
        months << [final_date.next_month(m).strftime("%b %Y"), final_date.next_month(m)]
      end
      months
    end

end
