class BookingMailer < ApplicationMailer
  default from: 'booking@roomieapp.io'

  def booking_group_email(recipients, booking_request)
    @recipients = recipients
    @listing = booking_request.listing
    @crew = booking_request.crew
    @users_names = []
    @crew.users.each do |user|
      @users_names << user.first_name
    end
    @start_date = @crew.start_date
    @end_date = @crew.end_date
    @request = booking_request
    emails = recipients.collect(&:email).join(",")
    mail(to: emails, subject: "Booking Request - #{booking_request.listing.title}")
  end
end
