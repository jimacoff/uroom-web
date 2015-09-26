class BookingRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    listings = Listing.where(owner: current_user)
    @requests = BookingRequest.where(listing: listings, rejected: false, accepted: false)
    render 'dashboard/bookingrequests'
  end

  def show
    @request = BookingRequest.find(params[:id])
    @users = @request.crew.users
    @listing = @request.listing
    @start_date = @request.crew.start_date
    @end_date = @request.crew.end_date
    if @request.listing.owner != current_user
      direct_to bookingrequests_path
    end
  end

  # Start group email
  # Mark request as accepted
  def accept
    @request = BookingRequest.find(params[:id])
    @request.update(accepted: true)
    @request.crew.update(approved: true)
    recipients = @request.crew.users + [@request.listing.owner]
    BookingMailer.booking_group_email(recipients, @request).deliver_now
    flash[:success] = "Accepted"
    redirect_to bookingrequests_path
  end

  # Send email saying was not approved
  # Mark request as rejected
  def reject
    @request = BookingRequest.find(params[:id])
    @request.update(rejected: true)
    @request.crew.update(requested: false)
    recipients = @request.crew.users
    BookingMailer.booking_rejected_email(recipients, @request).deliver_now
    flash[:success] = "Rejected"
    redirect_to bookingrequests_path
  end
end
