# frozen_string_literal: true
# PersonIndexer responsible for update the ES index
class PersonIndexer
  include Sidekiq::Worker

  def perform(person_id)
    person = Person.find(person_id)
    PeopleRepo.save(person)
  rescue ActiveRecord::RecordNotFound
    PeopleRepo.delete(person_id)
  end
end
