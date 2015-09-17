class BookingRequest < ActiveRecord::Base
  after_create :notify

  belongs_to :crew
  belongs_to :listing

  def notify
    owner = self.listing.owner
    if owner.present?
      # send notification email
    else
      # send invitation
      User.invite_landlord!(email: self.listing.email, username: self.listing.email, first_name: "", last_name: "", invited_booking_request: self, landlord: true)
    end
  end
end
