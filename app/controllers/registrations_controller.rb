class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  def edit_profile
    if user_signed_in?
      render :edit_profile
    else
      redirect_to user_session_path
    end
  end

  def update_profile
    current_user.update(profile_params)
    if current_user.save
      redirect_to :edit_profile
    else
      render :edit_profile
    end
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :regular_user, :landlord, :invited_booking_request, :invited_crew_request)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :passowrd, :password_confirmation, :current_password, :about, :avatar)
  end

  def profile_params
    params.require(:user).permit(:avatar, :about)
  end

end
