# frozen_string_literal: true

# Referral Address model which represents
# the join model between referral and address
class ReferralAddress < ActiveRecord::Base
  belongs_to :referral
  belongs_to :address

  accepts_nested_attributes_for :address
end
