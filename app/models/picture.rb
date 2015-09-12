class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image,
    hash_secret:Test2::Application.config.secret_token,
    styles: {large: "500x500", medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/:id/:style/:hash.:extension",
    url: "/system/:id/:style/:hash.:extension",
    default_url: "/images/:style/missing.png"

  do_not_validate_attachment_file_type :image
end
