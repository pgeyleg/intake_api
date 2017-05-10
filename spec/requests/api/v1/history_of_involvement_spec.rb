# frozen_string_literal: true

require 'rails_helper'

describe 'History of Involvement API', skip_auth: true do
  describe 'GET /api/v1/history_of_involvement' do
    let(:screening) { FactoryGirl.create :screening }

    context 'no participants in the screening' do
      it 'should return an empty array' do
        expect_any_instance_of(Screening).to receive(:history_of_involvements)
          .and_return([])
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'two participants exist on the screening' do
      let(:person1) { FactoryGirl.create :person }
      let!(:participant1) do
        FactoryGirl.create(
          :participant,
          person: person1,
          screening: screening
        )
      end

      let(:person2) { FactoryGirl.create :person }
      let!(:participant2) do
        FactoryGirl.create(
          :participant,
          person: person2,
          screening: screening
        )
      end
      let(:screenings) { [{ id: '123456789' }, { id: '987654321' }, { id: '456789123' }] }

      before do
        expect_any_instance_of(Screening).to receive(:history_of_involvements)
          .and_return(screenings)
      end

      it 'should return the relevant screening information' do
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true))
          .to match array_including(screenings)
      end
    end
  end
end
