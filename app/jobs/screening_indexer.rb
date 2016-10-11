# frozen_string_literal: true
# ScreeningIndexer responsible for update the ES index
class ScreeningIndexer
  include Sidekiq::Worker

  def perform(screening_id)
    screening = Screening.find(screening_id)
    ScreeningsRepo.save(screening)
  rescue ActiveRecord::RecordNotFound
    ScreeningsRepo.delete(screening_id)
  end
end
