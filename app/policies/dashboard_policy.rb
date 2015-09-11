class DashboardPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def index?
    user_signed_in?
  end

  def properties?
    @user.landlord
  end

  def following?
    @user.regular_user
  end

  def requests?
    @user.regular_user
  end

  def crews?
    @user.regular_user
  end

end
