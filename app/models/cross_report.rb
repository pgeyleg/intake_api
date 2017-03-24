# frozen_string_literal: true

# Cross report model that belongs to Screening
class CrossReport < ApplicationRecord
  belongs_to :screening, optional: true
end
