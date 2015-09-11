class CrewRequestsController < ApplicationController
  before_action :authenticate_user!

  def show
    @requset = Crew.find(params[:id])
  end

  # Accept request
  # Remove request from crew
  # Set orbit dates to crew dates
  # Add user to crew
  # Set orbit has_crew to true
  def accept_request
    request = CrewRequest.find(params[:id])
    crew = request.crew

    orbit = Orbit.find_by(user: current_user, listing: crew.listing)
    orbit.start_date = crew.start_date
    orbit.end_date = crew.end_date

    crew.users << current_user
    crew.crew_requests.delete(request)
    request.destroy # This might be redundant

    if crew.save && orbit.save
      redirect_to orbit.listing
    else
      flash[:error] = "Could not accept request"
      redirect_to dashboard_requests_path
    end
  end

  # Reject request
  # Remove request from crew
  def reject_request
    request = CrewRequest.find(params[:id])
    crew = request.crew

    crew.crew_requests.delete(request)
    crew.save # Might not be necessary
    request.destroy

    redirect_to dashboard_requests_path
  end
end
