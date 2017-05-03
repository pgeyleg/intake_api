# frozen_string_literal: true

# Participant model which represents a real world
# person on a screening
class Participant < ActiveRecord::Base
  has_paper_trail

  validates :screening, presence: true
  has_many :participant_addresses, inverse_of: :participant, dependent: :destroy
  has_many :addresses, through: :participant_addresses
  has_many :participant_phone_numbers, inverse_of: :participant, dependent: :destroy
  has_many :phone_numbers, through: :participant_phone_numbers
  belongs_to :screening
  belongs_to :person, optional: true

  ROLE_TYPES = [
    'Anonymous Reporter',
    'Mandated Reporter',
    'Non-mandated Reporter',
    'Perpetrator',
    'Victim'
  ].freeze

  after_update do |participant|
    unless participant.roles.include?('Victim')
      Allegation.where(victim_id: participant.id).destroy_all
    end

    unless participant.roles.include?('Perpetrator')
      Allegation.where(perpetrator_id: participant.id).destroy_all
    end
  end

  before_destroy do |participant|
    t = Allegation.arel_table
    Allegation.where(
      t[:victim_id].eq(participant.id).or(t[:perpetrator_id].eq(participant.id))
    ).destroy_all
  end
end
