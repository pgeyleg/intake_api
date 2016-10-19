# frozen_string_literal: true
# ScreeningIndexer responsible for update the ES index
class ScreeningIndexer
  def self.perform(screening_id)
    screening = Screening.find(screening_id)
    ScreeningsRepo.save(screening)
  rescue ActiveRecord::RecordNotFound
    ScreeningsRepo.delete(screening_id)
  end
end
