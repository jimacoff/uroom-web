class Chat < ActiveRecord::Base
  belongs_to  :crew
  has_many    :messages
end
