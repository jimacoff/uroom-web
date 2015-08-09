class CrewsController < ApplicationController

  # Create a crew. Done on a planet page.
  # May want to move this functionality to model
  # Only maintain methods here that require a view
  def create
    crew = Crew.new
    crew.users << current_user
    # add to current_user's orbit
    planet = current_user.planets.find(params[:planet])
    orbit = current_user.orbits.find_by(planet: planet)
    orbit.crew = crew
    orbit.save
    params[:users].each do |user_id|
      add_potential_user(user_id, crew)
    end
    crew.save
  end

  # Add a potential user to a Crew group
  # Does not make them a full member
  # Sends request to user to accept crew for listing
  def add_potential_user(user_id, crew)
    # Only for existing Crews
    user = User.find(user_id)

    # create request
    request = CrewRequest.new
    request.user = user
    request.crew = crew
    if request.save
      crew.potential_users << user
      # crew.save
    end

  end

  # User rejects offer to join a crew
  # Move user to rejected/remove from potential
  # User should be able to be added again if desired (limit the num of times)
  # Delete the request from the table
  def reject_offer
    # move user from potential to rejected
    user = current_user
    request = CrewRequest.find(params[:request_id])
    if request.user = user
      crew = request.crew
      crew.potential_users.delete(user)
      crew.rejected_users << user
      crew.save
      request.delete
    end
  end

  # User accpets offer to join a crew
  # User can no longer join other crews for that planet
  # User is full member of the crew and can chat 
  def accept_offer
    # move user from potential to accepted
    # assign user's crew for this orbit
    # request has crew reference, get orbit from it
    user = current_user
    request = CrewRequest.find(params[:request_id])
    if request.user = user
      crew = request.crew
      crew.users << user
      crew.potential_users.delete(user)
      crew.save
      request.delete
    end
  end

  # Remove the current, logged in user from the crew
  # Ask for confirmation. User cannot rejoin a crew they left
  # Delete crew if all users have left the crew
  def leave_crew

  end

end
