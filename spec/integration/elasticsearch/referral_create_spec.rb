# frozen_string_literal: true
require 'rails_helper'

describe 'Screening Active Record and Elastic Search integration' do
  it 'creates a screening document in ES', truncation: true do
    ScreeningsRepo.create_index! force: true
    screening = Screening.create(reference: 'Bart')
    screening_data_from_es = ScreeningsRepo.find(screening.id)
    expect(screening_data_from_es['reference']).to eq(screening.reference)
  end
end
