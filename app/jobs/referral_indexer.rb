# frozen_string_literal: true
# ReferralIndexer responsible for update the ES index
class ReferralIndexer
  include Sidekiq::Worker

  def perform(screening_id)
    screening = Screening.find(screening_id)
    ReferralsRepo.save(screening)
  rescue ActiveRecord::RecordNotFound
    ReferralsRepo.delete(screening_id)
  end
end
