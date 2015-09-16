class SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
       edit_profile_path
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end

end
