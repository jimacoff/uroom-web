class CrewsController < ApplicationController

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

end
