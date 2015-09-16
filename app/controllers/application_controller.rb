class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.invited_booking_request
      request = BookingRequest.find(resource.invited_booking_request_id)
      resource.invited_booking_request_id = nil
      bookingrequest_path(id: request)
    elsif resource.invited_crew
      request = CrewRequest.find(resource.invited_booking_request_id)
      listing = request.listing
      if add_invited_crew_member(request, listing)

      else
        flash[:error] = "Could not add you to the crew"
      end
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
