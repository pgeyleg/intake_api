# frozen_string_literal: true

# Screening model which represents the screening
class Screening < ActiveRecord::Base
  has_one :referral_address, inverse_of: :screening
  has_one :address, through: :referral_address
  has_many :referral_people
  has_many :involved_people, through: :referral_people, source: :person

  accepts_nested_attributes_for :address

  after_commit :index_async

  def index_async
    ReferralIndexer.perform_async(id)
  end
end
