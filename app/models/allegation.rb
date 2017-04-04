# frozen_string_literal: true
# Allegation model
class Allegation < ActiveRecord::Base
  validates :allegation_types, presence: true
  belongs_to :screening
end
