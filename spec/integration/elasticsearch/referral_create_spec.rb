# frozen_string_literal: true
require 'rails_helper'
require 'sidekiq/api'
require 'sidekiq/testing'

describe 'Screening Active Record and Elastic Search integration' do
  it 'should enqueue a screening indexer job', truncation: true do
    Sidekiq::Testing.disable!
    sidekiq_queue = Sidekiq::Queue.new
    sidekiq_queue.clear
    expect(sidekiq_queue.size).to eq(0)

    screening = Screening.create
    expect(sidekiq_queue.size).to eq(1)

    job_data = sidekiq_queue.first.item
    expect(job_data['class']).to eq('ScreeningIndexer')
    expect(job_data['args'].first).to eq(screening.id)
  end

  it 'creates a screening document in ES with inline sidekiq', truncation: true do
    Sidekiq::Testing.inline! do
      sidekiq_queue = Sidekiq::Queue.new
      sidekiq_queue.clear
      expect(sidekiq_queue.size).to eq(0)

      ScreeningsRepo.create_index! force: true
      screening = Screening.create(reference: 'Bart')
      screening_data_from_es = ScreeningsRepo.find(screening.id)
      expect(screening_data_from_es['reference']).to eq(screening.reference)
    end
  end
end
