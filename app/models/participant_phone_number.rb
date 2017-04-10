# frozen_string_literal: true

# Participant PhoneNumber model which represents
# the join model between participant and phonenumber
class ParticipantPhoneNumber < ActiveRecord::Base
  belongs_to :participant
  belongs_to :phone_number, dependent: :destroy
end
