class CrewsController < ApplicationController
  before_action :authenticate_user!
  # Create a crew. Done on a listing page.

  def create
    crew = Crew.new
    crew.admin = current_user
    crew.users << current_user
    orbit = Orbit.find(params[:orbit])

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
      orbit.update_attributes(has_crew: true)
      # redirect to listing
    else
      # render listing page
    end
  end

  def add_user
    crew = Crew.find(params[:id])
    user = User.find(params[:user])
    crew.users << user
    if crew.save
      # redirect to listing
    else
      # render page
    end
  end

  def remove_user
    crew = Crew.find(params[:crew])
    user = user.find(params[:user])
    if crew.admin == current_user
      crew.users.delete(user)
      crew.save
    else
      # render you don't have permission
    end
  end


  # Remove the current, logged in user from the crew
  # Delete crew if all users have left the crew
  def leave_crew
    crew = Crew.find(:crew)
    crew.users.delete(current_user)

    if crew.admin == current_user
      crew.admin = crew.users.first
    end

    if crew.users.count == 0
      crew.destroy
    end

    # redirect to listing page
  end

end
