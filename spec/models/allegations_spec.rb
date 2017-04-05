# frozen_string_literal: true
require 'rails_helper'

describe Allegation do
  describe 'validations' do
    describe 'allegations_types' do
      it 'cannot be an empty array' do
        allegation = FactoryGirl.build(:allegation, allegation_types: [])
        expect(allegation.valid?).to be false
        expect(allegation.errors).to have_key(:allegation_types)
        expect(allegation.errors[:allegation_types]).to include("can't be blank")
      end
      it 'cannot be blank' do
        allegation = FactoryGirl.build(:allegation, allegation_types: nil)
        expect(allegation.valid?).to be false
        expect(allegation.errors).to have_key(:allegation_types)
        expect(allegation.errors[:allegation_types]).to include("can't be blank")
      end
      it 'are valid when an array of strings' do
        allegation = FactoryGirl.build(:allegation, allegation_types: ['one'])
        allegation.valid?
        expect(allegation.errors).not_to have_key(:allegation_types)
      end
    end
  end
end
