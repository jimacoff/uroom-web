class Users::InvitationsController < Devise::InvitationsController

  private
    def accept_resource
      resource = resource_class.accept_invitation!(update_resource_params)
      booking_request = BookingRequest.find(resource.invited_booking_request_id)
      listing = booking_request.listing
      listing.owner = resource
      listing.save
      resource
    end
end
