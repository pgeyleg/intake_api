# frozen_string_literal: true

# Screening model which represents the screening
class Screening < ActiveRecord::Base
  has_one :screening_address, inverse_of: :screening
  has_one :address, through: :screening_address
  has_many :screening_people
  has_many :involved_people, through: :screening_people, source: :person

  accepts_nested_attributes_for :address

  after_commit :index_async

  def index_async
    ScreeningIndexer.perform_async(id)
  end
end
