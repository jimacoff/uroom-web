class InviteMailer < Devise::Mailer

  def landlord_invitation_instructions(record, opts={})
    opts = {subject: "Craigslist listing"}
    @token = record.raw_invitation_token
    devise_mail(record, :landlord_invitation_instructions, opts)
  end

  def friend_invitation_instructions(record, opts={})
    devise_mail(record, :friend_invitation_instructions, opts)
  end

end
