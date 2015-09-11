class Gallery < ActiveRecord::Base
  belongs_to :listing
  has_many :pictures, :dependent => :destroy
end
