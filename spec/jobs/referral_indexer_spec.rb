# frozen_string_literal: true
require 'rails_helper'

describe ReferralIndexer do
  it 'indexes the Screening data in elastic search when screening is found' do
    screening = double(:screening, id: 1)
    allow(Screening).to receive(:find)
      .with(screening.id)
      .and_return(screening)
    expect(ReferralsRepo).to receive(:save).with(screening)
    described_class.new.perform(screening.id)
  end

  it 'deletes Screening data from elastic search when screening is not found' do
    screening = double(:screening, id: 1)
    allow(Screening).to receive(:find)
      .with(screening.id)
      .and_raise(ActiveRecord::RecordNotFound)
    expect(ReferralsRepo).to receive(:delete).with(screening.id)
    described_class.new.perform(screening.id)
  end
end
