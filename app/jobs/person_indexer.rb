# frozen_string_literal: true
# PersonIndexer responsible for update the ES index
class PersonIndexer
  def self.perform(person_id)
    person = Person.find(person_id)
    PeopleRepo.save(person)
  rescue ActiveRecord::RecordNotFound
    PeopleRepo.delete(person_id)
  end
end
