class CrewsController < ApplicationController

  def create
    crew = Crew.new
    # crew.users << current_user
  end

  def add_potential_user
    # Only for existing Crews
  end

  def reject_offer
    # move user from potential to rejected
  end

  def accept_offer
    # move user from potential to accepted
  end

end
