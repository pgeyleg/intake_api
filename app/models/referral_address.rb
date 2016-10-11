# frozen_string_literal: true

# Referral Address model which represents
# the join model between screening and address
class ReferralAddress < ActiveRecord::Base
  belongs_to :screening
  belongs_to :address
end
