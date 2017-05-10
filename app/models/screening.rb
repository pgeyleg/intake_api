# frozen_string_literal: true

# Screening model which represents the screening
class Screening < ActiveRecord::Base
  has_paper_trail

  has_one :screening_address, inverse_of: :screening
  has_one :address, through: :screening_address
  has_many :participants
  has_many :cross_reports, dependent: :destroy
  has_many :allegations, inverse_of: :screening

  accepts_nested_attributes_for :address, :allegations, :cross_reports

  after_commit :reindex

  def reindex
    ScreeningIndexer.perform(id)
  end

  # This cleans up existing cross reports if a new list is submitted
  def cross_reports_attributes=(*attrs)
    cross_reports.destroy_all
    super(*attrs)
  end

  def people_ids
    participants.pluck(:person_id).compact
  end

  def history_of_involvements
    ids = people_ids
    if ids.present?
      PersonRepository
        .find(ids)
        .map { |result| result[:screenings] }
        .flatten.compact.uniq { |screening| screening[:id] }
    else
      []
    end
  end

  def participants_with_relationships
    ids = people_ids
    results = people_ids.present? ? PersonRepository.find(ids) : []
    participants.each do |participant|
      result = results.find { |r| r[:id] == participant.person_id }
      relationships = result && result[:relationships] ? result[:relationships] : []
      participant.relationships = relationships
    end
  end
end
