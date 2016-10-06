# frozen_string_literal: true
# ReferralIndexer responsible for update the ES index
class ReferralIndexer
  include Sidekiq::Worker

  def perform(referral_id)
    referral = Referral.find(referral_id)
    ReferralsRepo.save(referral)
  rescue ActiveRecord::RecordNotFound
    ReferralsRepo.delete(referral_id)
  end
end
