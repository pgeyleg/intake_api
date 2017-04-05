# frozen_string_literal: true
# Allegation model
class Allegation < ActiveRecord::Base
  validates :allegation_types, presence: true
  belongs_to :screening
  belongs_to :victim, class_name: 'Participant'
  belongs_to :perpetrator, class_name: 'Participant'
end
