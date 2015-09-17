class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.invited_booking_request
      booking_request = resource.invited_booking_request
      resource.update_attributes(invited_booking_request: nil)
      bookingrequest_path(id: booking_request)
    elsif resource.invited_crew_request
      listing = resource.invited_crew_request.crew.listing
      resource.update_attributes(invited_crew_request: nil)
      listing_path(id: listing)
    elsif resource.sign_in_count == 1
       edit_profile_path
    else
      sign_in_url = new_user_session_url
      if request.referer == sign_in_url
        super
      else
        stored_location_for(resource) || request.referer || root_path
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

end
