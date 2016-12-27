# frozen_string_literal: true
# Person model which represents a real world person
class Person < ActiveRecord::Base
  has_many :person_addresses, inverse_of: :person
  has_many :addresses, through: :person_addresses
  has_many :person_phone_numbers, inverse_of: :person
  has_many :phone_numbers, through: :person_phone_numbers

  after_commit :reindex

  def reindex
    PersonIndexer.perform(id)
  end
end
