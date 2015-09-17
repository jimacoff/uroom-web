class Users::InvitationsController < Devise::InvitationsController

  private
    def accept_resource
      resource = resource_class.accept_invitation!(update_resource_params)
      if resource.invited_booking_request
        resource.invited_booking_request.listing.update(owner: resource)
        resource.update(landlord: true)
      elsif resource.invited_crew_request
        crew_request = resource.invited_crew_request
        crew = crew_request.crew
        orbit = Orbit.create(listing: crew.listing, crew: crew, user: resource, start_date: crew.start_date, end_date: crew.end_date, has_crew: true)
        crew.users << resource
        crew_request.destroy
      end
      resource
    end

    def update_resource_params
      params.require(resource_name).permit(
        :invitation_token,
        :password,
        :password_confirmation,
        :first_name,
        :last_name,
        :username,
        :email
      )
    end
end
