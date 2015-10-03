class DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @user = current_user
    @my_properties = current_user.owned_listings
    @crew_requests = current_user.crew_requests
    @followed_listings = current_user.orbits
    @my_crews = current_user.crews
    if current_user.landlord
      redirect_to dashboard_myproperties_path
    else
      redirect_to dashboard_crews_path
    end
  end

  def properties
    @user = current_user
    @listings = current_user.owned_listings
  end

  def following
    @orbits = current_user.orbits
  end

  def requests
    @request = current_user.crew_requests
  end

  def crews
    @crews = current_user.crews
  end

end
