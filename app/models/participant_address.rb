# frozen_string_literal: true

# Participant Address model which represents
# the join model between participant and address
class ParticipantAddress < ActiveRecord::Base
  belongs_to :participant
  belongs_to :address
end
