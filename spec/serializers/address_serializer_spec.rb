# frozen_string_literal: true

require 'rails_helper'

describe AddressSerializer do
  describe 'as_json' do
    let(:address) { FactoryGirl.create(:address) }

    it 'returns the attributes of a address as a hash' do
      expect(described_class.new(address).as_json).to eq(
        id: address.id,
        street_address: address.street_address,
        state: address.state,
        city: address.city,
        zip: address.zip,
        type: address.type
      )
    end
  end
end
