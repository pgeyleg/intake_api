# frozen_string_literal: true
require 'rails_helper'

describe AddressSerializer do
  describe 'as_json' do
    it 'returns the attributes of a address as a hash' do
      address = Address.new(
        street_address: '9273 Corona St',
        state: 'NY',
        city: 'Jackson Heights',
        zip: 11_372
      )
      address.save!
      expect(
        described_class.new(address).as_json
      ).to eq(
        id: address.id,
        street_address: '9273 Corona St',
        state: 'NY',
        city: 'Jackson Heights',
        zip: 11_372
      )
    end
  end
end
