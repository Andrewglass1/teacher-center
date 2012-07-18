class DonationLog < ActiveRecord::Base
  attr_accessible :date, :amount_funded_cents
  belongs_to :project
end
