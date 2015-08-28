class CrewApprovalRequestPolicy
  attr_reader :user, :crew_approval_request

  def initialize(user, crew_approval_request)
    @user = user
    @crew_approval_request = crew_approval_request
  end

  def can_approve?
    @crew_approval_request.landlord == @user
  end

end
