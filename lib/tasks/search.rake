# frozen_string_literal: true
namespace :search do
  desc 'migrate'
  task migrate: :environment do
    PeopleRepo.create_index! force: true
  end

  desc 'reindex'
  task reindex: :environment do
    Person.find_each do |person|
      PeopleRepo.save(person)
    end
  end
end
