# frozen_string_literal: true

# Referral Person model which represents
# the join model between referral and person
class ReferralPerson < ActiveRecord::Base
  belongs_to :screening
  belongs_to :person
end
