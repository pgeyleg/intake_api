# frozen_string_literal: true
require 'rails_helper'

describe ReferralIndexer do
  it 'indexes the Referral data in elastic search when referral is found' do
    referral = double(:referral, id: 1)
    allow(Referral).to receive(:find)
      .with(referral.id)
      .and_return(referral)
    expect(ReferralsRepo).to receive(:save).with(referral)
    described_class.new.perform(referral.id)
  end

  it 'deletes Referral data from elastic search when referral is not found' do
    referral = double(:referral, id: 1)
    allow(Referral).to receive(:find)
      .with(referral.id)
      .and_raise(ActiveRecord::RecordNotFound)
    expect(ReferralsRepo).to receive(:delete).with(referral.id)
    described_class.new.perform(referral.id)
  end
end
