# frozen_string_literal: true
require 'rails_helper'

describe 'Relationships API', skip_auth: true do
  describe 'GET /api/v1/screenings/:id/relationships' do
    let(:screening) { FactoryGirl.create :screening }

    context 'no participants in the screening' do
      it 'should return an empty array' do
        expect_any_instance_of(Screening).to receive(:participants_with_relationships)
          .and_return([])
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'there are two participants with people ids' do
      let(:person1) { FactoryGirl.create :person }
      let!(:participant1) do
        FactoryGirl.create(
          :participant,
          person: person1,
          screening: screening,
          relationships: [{ related_person_id: 'rel_1_id' }]
        )
      end

      let(:person2) { FactoryGirl.create :person }
      let!(:participant2) do
        FactoryGirl.create(
          :participant,
          person: person2,
          screening: screening,
          relationships: [
            { related_person_id: 'rel_2_id' },
            { related_person_id: 'rel_3_id' }
          ]
        )
      end

      before do
        expect_any_instance_of(Screening).to receive(:participants_with_relationships)
          .and_return([participant1, participant2])
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
      end

      it 'should include relationships in the response' do
        expect(JSON.parse(response.body, symbolize_names: true)).to match(
          array_including(
            a_hash_including(
              id: participant1.id,
              first_name: participant1.first_name,
              last_name: participant1.last_name,
              relationships: [{ related_person_id: 'rel_1_id' }]
            ),
            a_hash_including(
              id: participant2.id,
              first_name: participant2.first_name,
              last_name: participant2.last_name,
              relationships:  [
                { related_person_id: 'rel_2_id' },
                { related_person_id: 'rel_3_id' }
              ]
            )
          )
        )
      end
    end
  end
end
