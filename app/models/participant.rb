# frozen_string_literal: true

# Participant model which represents a real world
# person on a screening
class Participant < ActiveRecord::Base
  has_many :participant_addresses, inverse_of: :participant
  has_many :addresses, through: :participant_addresses
  belongs_to :screening
  belongs_to :person
end
