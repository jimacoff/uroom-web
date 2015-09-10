class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  include RegistrationsHelper


  def edit_profile
    if user_signed_in?
      render :edit_profile
    else
      redirect_to user_session_path
    end
  end

  def update_profile
    current_user.about = params[:user][:about]
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
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :about, :passowrd, :password_confirmation, :current_password)
  end



end
