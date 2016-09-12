# frozen_string_literal: true
# Person model which represents a real world person
class Person < ActiveRecord::Base
  has_one :person_address, inverse_of: :person
  has_one :address, through: :person_address

  accepts_nested_attributes_for :address

  after_commit :index_async

  def index_async
    PersonIndexer.perform_async(id)
  end
end
