class ListingPolicy
  attr_reader :user, :listing

  def initialize(user, listing)
    @user = user
    @listing = listing
  end

  def show?
    true
  end

  def create?
    @user
  end

  def new?
    create?
  end

  def update?
    @listing.owner == @user || @user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    @listing.owner == @user || @user.admin?
  end

  def orbit?
    @user.regular_user || @user.admin?
  end

  def unorbit?
    @user.regular_user || @user.admin?
  end

  def request?
    crew = Crew.where(listing: @listing, user: @user).first
    @user == crew.crew_admin
  end


end
