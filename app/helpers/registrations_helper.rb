module RegistrationsHelper
  def resource_name
    :user
  end

  def resource
    if current_user
      @resource = current_user
    else
      @resource ||= current_user

  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
