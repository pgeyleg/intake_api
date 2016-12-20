# frozen_string_literal: true
require 'rails_helper'

describe PhoneNumberSerializer do
  describe 'as_json' do
    let(:phoneNumber) do
      PhoneNumber.new(
        number: '917-901-8765',
        type: 'Home',
        created_at: '2016-12-03T22:08:38.204Z',
        updated_at: '2016-12-03T22:08:38.204Z'
      )
    end

    before { phoneNumber.save! }

    it 'returns the attributes of a phoneNumbers as a hash' do
      expect(described_class.new(phoneNumber).as_json).to eq(
        id: phoneNumber.id,
        number: '917-901-8765',
        type: 'Home',
        created_at: '2016-12-03T22:08:38.204Z',
        updated_at: '2016-12-03T22:08:38.204Z'
      )
    end
  end
end
