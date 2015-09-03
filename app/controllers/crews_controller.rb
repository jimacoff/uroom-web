class CrewsController < ApplicationController
  before_action :authenticate_user!
  # Create a crew. Done on a listing page.

  def create
    crew = Crew.new
    crew.crew_admin = current_user
    crew.users << current_user
    orbit = Orbit.find(params[:orbit])

    orbit.crew = crew
    #orbit.save

    crew.listing = orbit.listing
    crew.start_date = orbit.start_date
    crew.end_date = orbit.end_date

    crew_requests = []
    params[:users].each do |user_id|
      crew_request = CrewRequest.new
      crew_request.user_id = user_id
      crew_request.crew = crew

      crew_requests << crew_request
    end

    if crew.save
      crew_requests.each do |request| request.save  end
      orbit.update_attributes(has_crew: true) # current_user's orbit
      flash[:success] = "Sent crew requests!"
    else
      # render listing page
      flash[:error] = "Failed to create crew."
    end
    redirect_to crew.listing
  end

  # Create new crew request
  def add_user
    user = User.find(params[:user])
    crew = Crew.find(params[:id])

    crew_request = CrewRequest.new
    crew_request.user = user
    crew_request.crew = crew

    if crew_request.save
      # redirect to listing
    else
      # render page
    end
  end

  def remove_user
    crew = Crew.find(params[:crew])
    user = user.find(params[:user])

    if crew.admin == current_user
      # Remove user from crew
      crew.users.delete(user)
      crew.save

      crew.users.each do |crew_member|
        orbit = Orbit.find_by(user: crew_member, listing: crew.listing)
        if crew_member == user # If the user is the one that was removed
          orbit.has_crew = false
        end
        orbit.ready_to_land = false
        oribt.landed = false
        orbit.save
      end
    else
      # render you don't have permission
    end
  end

  # Remove the current, logged in user from the crew
  # Delete crew if all users have left the crew
  # If user leaves the crew, set orbit to have no crew
  # If a user leaves the crew, everyone in crew no longer is ready_to_land
  # and is no longer landed
  def leave_crew
    crew = Crew.find(:crew)

    crew.users.each do |user|
      orbit = Orbit.find_by(user: user, listing: crew.listing)
      if user == current_user
        orbit.has_crew = false
        crew.users.delete(current_user)
      end
      orbit.ready_to_land = false
      oribt.landed = false
      orbit.save
    end

    if crew.admin == current_user
      crew.admin = crew.users.first
    end

    if crew.users.count == 0
      crew.destroy
    end

    # redirect to listing page
  end

  def ready_to_land
    @crew = Crew.find(:crew)

    orbit = Orbit.find_by(user: current_user, listing: @crew.listing)
    orbit.ready_to_land = true
    orbit.save

    all_are_ready = true
    @crew.users.each do |user|
      orbit = Orbit.find_by(user: user, listing: crew.listing)
      if orbit.ready_to_land == false
        all_are_ready = false
      end
    end

    if orbit.save
      if all_are_ready
        @crew.ready_to_land = true
        if @crew.save
          request_landing
        else
          redirect_to @crew.listing
        end
      else
        flash[:success] = "You have been set to ready"
        redirect_to @crew.listing
      end
    else
      flash[:error] = "Could not set ready"
      redirect_to @crew.listing
    end
  end

  def not_ready_to_land
    crew = Crew.find(:crew)

    orbit = Orbit.find_by(user: current_user, listing: @crew.listing)
    orbit.ready_to_land = false

    if orbit.save
      flash[:notice] = "You are no longer ready to land"
    else
      flash[:error] = "Could not set as not ready"
    end
    redirect_to crew.listing
  end

  def request_landing
    @crew = Crew.find(:crew) if params[:crew]

    approval_request = CrewApprovalRequest.new
    approval_request.crew         = @crew
    approval_request.listing      = @crew.listing
    approval_request.landlord     = @crew.listing.owner
    approval_request.start_date   = @crew.start_date
    approval_request.lease_length = @crew.lease_length

    if approval_request.save
      flash[:success] = "All users are ready, leasing request made"
    else
      flash[:error] = "Landing request could not be made"
    end

    redirect_to @crew.listing
  end

end
