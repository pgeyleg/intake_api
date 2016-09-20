# frozen_string_literal: true
require 'rails_helper'
require 'sidekiq/api'
require 'sidekiq/testing'

describe 'Referral Active Record and Elastic Search integration' do
  it 'should enqueue a referral indexer job', truncation: true do
    Sidekiq::Testing.disable!
    sidekiq_queue = Sidekiq::Queue.new
    sidekiq_queue.clear
    expect(sidekiq_queue.size).to eq(0)

    referral = Referral.create
    expect(sidekiq_queue.size).to eq(1)

    job_data = sidekiq_queue.first.item
    expect(job_data['class']).to eq('ReferralIndexer')
    expect(job_data['args'].first).to eq(referral.id)
  end

  it 'creates a referral document in ES with inline sidekiq', truncation: true do
    Sidekiq::Testing.inline! do
      sidekiq_queue = Sidekiq::Queue.new
      sidekiq_queue.clear
      expect(sidekiq_queue.size).to eq(0)

      ReferralsRepo.create_index! force: true
      referral = Referral.create(reference: 'Bart')
      referral_data_from_es = ReferralsRepo.find(referral.id)
      expect(referral_data_from_es['reference']).to eq(referral.reference)
    end
  end
end
