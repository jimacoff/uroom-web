class Crew < ActiveRecord::Base
  after_create :make_chat

  belongs_to :listing
  belongs_to :crew_admin, class_name: "User"
  has_one    :crew_approval_request
  has_one    :chat

  has_many :crew_requests
  has_many :user_crew_memberships
  has_many :users, through: :user_crew_memberships

  private
    def make_chat
      chat = Chat.create
      self.chat = chat
      chat.save
    end

end
