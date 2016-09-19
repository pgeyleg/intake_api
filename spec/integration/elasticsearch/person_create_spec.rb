# frozen_string_literal: true
require 'rails_helper'
require 'sidekiq/api'

describe 'Person Active Record and Elastic Search integration' do
  it 'should enqueue a person indexer job', truncation: true do
    sidekiq_queue = Sidekiq::Queue.new
    sidekiq_queue.clear

    expect(sidekiq_queue.size).to eq(0)

    person = Person.create(first_name: 'Bart', last_name: 'Simpson')

    expect(sidekiq_queue.size).to eq(1)
    job_data = sidekiq_queue.first.item
    expect(job_data['class']).to eq('PersonIndexer')
    expect(job_data['args'].first).to eq(person.id)
  end

  it 'creates a person document in ES with inline sidekiq', truncation: true do
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!

    sidekiq_queue = Sidekiq::Queue.new
    sidekiq_queue.clear

    expect(sidekiq_queue.size).to eq(0)
    PeopleRepo.create_index! force: true

    person = Person.create(first_name: 'Bart', last_name: 'Simpson')

    person_data_from_es = PeopleRepo.find(person.id)
    expect(person_data_from_es['first_name']).to eq(person.first_name)
    expect(person_data_from_es['last_name']).to eq(person.last_name)
  end
end
