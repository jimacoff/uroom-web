class BookingRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    listings = Listing.where(owner: current_user)
    @requests = BookingRequest.where(listing: listings)
    render 'dashboard/bookingrequests'
  end

  def show
    @request = BookingRequest.find(params[:id])
    if @request.listing.owner != current_user
      # redirect to requests dashboard
    end
  end

  def accept
    # Start group email
    # Mark request as accepted
    @request = BookingRequest.find(params[:id])
    @request.update(accepted: true)
    recipients = @request.crew.users + [@request.listing.owner]
    BookingMailer.booking_group_email(recipients, @request).deliver_now
    flash[:success] = "Accepted"
    redirect_to @request.listing
    # redirect_to booking requests dashboard
  end

  def reject
    # Send email saying was not approved
    # Mark request as rejected
    # You can always submit another request
  end
end
