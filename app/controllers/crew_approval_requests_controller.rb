class CrewApprovalRequestsController < ApplicationController
  before_action :authenticate_user!
  
  def my_requests
    @requests = CrewApprovalRequest.where(crew: current_user.crews.map(:id))
  end

  def landlord_requests
    @requests = CrewApprovalRequest.where(landlord: current_user)
  end

  def accept
    @request = CrewApprovalRequest.find(:id)
    authorize @request, :can_approve?
    @request.approved = true
    @request.crew.approved = true
    @request.save
    @request.crew.save
  end

  def reject
    @request = CrewApprovalRequest.find(:id)
    authorize @request, :can_approve?
    @request.rejected = true
    @request.save
  end
end
