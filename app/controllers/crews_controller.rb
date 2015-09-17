class CrewsController < ApplicationController
  before_action :authenticate_user!

  # Create a crew. Done on a listing page.
  def create
    orbit = Orbit.find(params[:orbit])
    crew = Crew.create(crew_admin: current_user, users: [current_user], listing: orbit.listing, start_date: orbit.start_date, end_date: orbit.end_date)

    params[:users].split(',').each do |user_id|
      requested_user = User.find(user_id)
      crew_request = CrewRequest.create(user: requested_user, crew: crew) if requested_user
    end

    params[:emails].split(' ').each do |email|
      user = User.find_by(email: email)
      crew_request = CrewRequest.create(user: user, crew: crew)
      if user.nil?
        user = User.invite_friend!(email: email, username: email, first_name: "", last_name: "", invited_crew_request: crew_request, regular_user: true)
        crew_request.update(user: user)
      end
    end

    if orbit.update_attributes(crew: crew)
      flash[:success] = "Sent crew requests!"
    else
      flash[:error] = "Failed to create crew."
    end
    redirect_to crew.listing
  end


  # Create new crew request
  def add_user
    crew = Crew.find(params[:crew])
    params[:emails].split(' ').each do |email|
      user = User.find_by(email: email)
      crew_request = CrewRequest.create(crew: crew, user: user)
      if user.nil?
        username = email.split("@").first
        user = User.invite_friend!(email: email, username: username, first_name: "", last_name: "", invited_crew_request: crew_request, regular_user: true)
        crew_request.update(user: user)
      end
      crew.crew_requests << crew_request
    end

    if crew.save
      flash[:success] = "Invited people to group"
    else
      flash[:error] = "Could not invite people to group"
    end
    redirect_to crew.listing
  end

  def remove_user
    crew = Crew.find(params[:crew])
    user = user.find(params[:user])

    if crew.crew_admin == current_user
      crew.users.each do |crew_member|
        orbit = Orbit.find_by(user: crew_member, listing: crew.listing)
        if crew_member == user # If the user is the one that was removed
          orbit.has_crew = false
        end
        orbit.ready_to_land = false
        oribt.landed = false
        orbit.save
      end
      crew.users.delete(user)
      crew.save
    else
      flash[:error] = "You don't have permission to do that"
    end

    redirect_to crew.listing
  end

  # Remove the current, logged in user from the crew
  # Delete crew if all users have left the crew
  # If user leaves the crew, set orbit to have no crew
  # If a user leaves the crew, everyone in crew no longer is ready_to_land
  # and is no longer landed
  def leave_crew
    crew = Crew.find(params[:crew])
    listing = crew.listing

    crew.users.each do |user|
      orbit = Orbit.find_by(user: user, listing: listing)
      if user == current_user
        orbit.update_attributes(crew: nil)
        crew.users.delete(current_user)
      end
      orbit.update_attributes(ready_to_land: false, landed: false)
    end

    if crew.users.count == 0
      crew.crew_requests.each do |request| request.destroy end
      crew.destroy
    elsif crew.crew_admin == current_user
      crew.crew_admin = crew.users.first
      crew.save
    end

    redirect_to listing
  end

  # def ready_to_land
  #   @crew = Crew.find(:crew)
  #
  #   orbit = Orbit.find_by(user: current_user, listing: @crew.listing)
  #   orbit.ready_to_land = true
  #   orbit.save
  #
  #   all_are_ready = true
  #   @crew.users.each do |user|
  #     orbit = Orbit.find_by(user: user, listing: crew.listing)
  #     if orbit.ready_to_land == false
  #       all_are_ready = false
  #     end
  #   end
  #
  #   if orbit.save
  #     if all_are_ready
  #       @crew.ready_to_land = true
  #       if @crew.save
  #         request_landing
  #       else
  #         redirect_to @crew.listing
  #       end
  #     else
  #       flash[:success] = "You have been set to ready"
  #       redirect_to @crew.listing
  #     end
  #   else
  #     flash[:error] = "Could not set ready"
  #     redirect_to @crew.listing
  #   end
  # end
  #
  # def not_ready_to_land
  #   crew = Crew.find(:crew)
  #
  #   orbit = Orbit.find_by(user: current_user, listing: @crew.listing)
  #   orbit.ready_to_land = false
  #
  #   if orbit.save
  #     flash[:notice] = "You are no longer ready to land"
  #   else
  #     flash[:error] = "Could not set as not ready"
  #   end
  #   redirect_to crew.listing
  # end
  #
  # def request_landing
  #   @crew = Crew.find(:crew) if params[:crew]
  #
  #   approval_request = CrewApprovalRequest.new
  #   approval_request.crew         = @crew
  #   approval_request.listing      = @crew.listing
  #   approval_request.landlord     = @crew.listing.owner
  #   approval_request.start_date   = @crew.start_date
  #   approval_request.lease_length = @crew.lease_length
  #
  #   if approval_request.save
  #     flash[:success] = "All users are ready, leasing request made"
  #   else
  #     flash[:error] = "Landing request could not be made"
  #   end
  #
  #   redirect_to @crew.listing
  # end

end
