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
    
    # user = User.find(user_id)
    # Create request, with crew

  end

  def reject_offer
    # move user from potential to rejected
  end

  def accept_offer
    # move user from potential to accepted
    # assign user's crew for this orbit
    # request has crew reference, get orbit from it
  end

end
