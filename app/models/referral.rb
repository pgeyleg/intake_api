# frozen_string_literal: true

# Referral model which represents the referral
class Referral < ActiveRecord::Base
  has_one :referral_address, inverse_of: :referral
  has_one :address, through: :referral_address

  accepts_nested_attributes_for :address
end
