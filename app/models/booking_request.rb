class BookingRequest < ActiveRecord::Base
  after_create :notify

  belongs_to :crew
  belongs_to :listing

  def notify
    owner = self.listing.owner
    if owner
      # send notification email
    else
      # send invitation
      email = self.listing.email
      username = email.split("@").first
      User.invite_landlord!(email: email, username: username, first_name: "", last_name: "", invited_booking_request: self, landlord: true)
    end
  end
end
