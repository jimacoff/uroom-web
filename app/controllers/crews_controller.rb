class CrewsController < ApplicationController

  def create
    crew = Crew.new
    # crew.users << current_user
    params[:users].each do |user_id|
      add_potential_user(user_id)
    end
  end

  def add_potential_user(user_id)
    # Only for existing Crews
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
