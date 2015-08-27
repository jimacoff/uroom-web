class DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!


  def index
    @user = current_user
    @my_properties = current_user.owned_listings
    @crew_requests = current_user.crew_requests
    @followed_listings = current_user.orbits
    @my_crews = current_user.crews
  end

  def properties
    @user = current_user
    @listings = current_user.owned_listings
  end

end
