# frozen_string_literal: true

# Cross report model that belongs to Screening
class CrossReport < ApplicationRecord
  has_paper_trail

  belongs_to :screening, optional: true
end
