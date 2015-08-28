class CrewApprovalRequest < ActiveRecord::Base
  belongs_to :crew
  belongs_to :landlord, class_name: "User"
end
