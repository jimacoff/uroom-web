class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image,
    hash_secret: '3dc4ae38d8884935e31bde595c06001d153982069650c1c4e326a47c69e723ee970e7cb0ef334b1fdf32e1e8d7e7cd31a92abaa828c349360b81293d47af2d41',
    styles: {large: "500x500", medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/:id/:style/:hash.:extension",
    url: "/system/:id/:style/:hash.:extension",
    default_url: "/images/:style/missing.png"

  do_not_validate_attachment_file_type :image
end
