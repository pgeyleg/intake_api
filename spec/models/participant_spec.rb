# frozen_string_literal: true
require 'rails_helper'

describe Participant do
  it 'is valid without a person_id' do
    participant = described_class.new(person_id: nil)
    participant.valid?
    expect(participant.errors).not_to have_key(:person)
  end

  it 'requires a screening' do
    participant = described_class.new(screening_id: nil)
    participant.valid?
    expect(participant.errors[:screening]).to include('must exist')
  end
end
