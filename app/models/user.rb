class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" },
      default_url: "/images/:style/missing.png",
      url: "/system/:id/:style/:hash.:extension",
      hash_secret: '3dc4ae38d8884935e31bde595c06001d153982069650c1c4e326a47c69e723ee970e7cb0ef334b1fdf32e1e8d7e7cd31a92abaa828c349360b81293d47af2d41'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_many :crew_requests
  has_many :user_crew_memberships
  has_many :crews, through: :user_crew_memberships

  has_many :orbits
  has_many :listings, through: :orbits

  has_many :crew_approval_requests
  has_many :owned_listings, class_name: "Listing", foreign_key: "owner_id"

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(' ').first   # assuming the user model has a name
      user.last_name = auth.info.name.split(' ').last
      user.username = "facebook:#{auth.uid}"
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
