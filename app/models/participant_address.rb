# frozen_string_literal: true

# Participant Address model which represents
# the join model between participant and address
class ParticipantAddress < ActiveRecord::Base
  has_paper_trail

  belongs_to :participant
  belongs_to :address, dependent: :destroy
end
