class ListingsController < ApplicationController
  include ListingsHelper
  layout "dashboard", only: [:edit]
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :orbit, :land, :update_date]


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

    if params[:date]
      get_params
      if user_signed_in?
        @followers = @listing.users.references( :orbits ).where( orbits: { start_date: @start_date, end_date: @end_date, has_crew: false })
        @followers -= [current_user] if @followers
      end
    else
      if @orbit.present?
        @start_date = @orbit.start_date
        @end_date = @orbit.end_date
        @date = @start_date
        # calculate lease length
      end
    end
  end

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
      orbit = Orbit.new(user: current_user,  listing: @listing,
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
    @listing = Listing.find(params[:id])
    # If crew is approved
    # Set listing to not active
    # Set tenant crew to current Crew
    # Set user's tenant listing to this listing
    # Delete orbit
    # Redirect to lease registration
    client = HelloSign::Client.new :api_key => 'SIGN_IN_AND_CONFIRM_EMAIL_TO_SEE_YOUR_API_KEY_HERE'
    client.create_embedded_signature_request(
        :test_mode => 1,
        :client_id => 'YOUR_CLIENT_ID',
        :subject => 'My First embedded signature request',
        :message => 'Awesome, right?',
        :signers => [
            {
                :email_address => 'tonyfrancisv@gmail.com',
                :name => 'Me'
            }
        ],
        :files => ['NDA.pdf']
    )
    client.get_embedded_sign_url :signature_id => 'SIGNATURE_ID'
    render 'land'
  end

  private

    def get_params
      @listing = Listing.find(params[:id])
      @roommates = params[:roommates].to_i
      @lease_length = params[:lease_length].to_i
      @date = params[:date]

      @start_date = start_date(@date[:month].to_i, @date[:year].to_i)
      @end_date = end_date(@start_date, @lease_length)
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
                                              :bathrooms)
    end

end
