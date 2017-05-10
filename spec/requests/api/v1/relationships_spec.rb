# frozen_string_literal: true
require 'rails_helper'

describe 'Relationships API', skip_auth: true do
  describe 'GET /api/v1/screenings/:id/relationships' do
    let(:screening) { FactoryGirl.create :screening }

    context 'no participants in the screening' do
      it 'should return an empty array' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'one participant without a person id exists on the screening' do
      let!(:participant) do
        FactoryGirl.create(
          :participant,
          screening: screening
        )
      end

      it 'returns the relevant information about the participant' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)).to match(
          array_including(
            a_hash_including(
              id: participant.id,
              first_name: participant.first_name,
              last_name: participant.last_name,
              relationships: []
            )
          )
        )
      end
    end

    context 'one participant with a person id exists on the screening' do
      let(:person) { FactoryGirl.create :person }
      let!(:participant) do
        FactoryGirl.create(
          :participant,
          person: person,
          screening: screening
        )
      end

      before do
        expect(PersonRepository).to receive(:find).with([person.id])
          .and_return(person_repository_response)
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
      end

      context 'the participant has no people search results' do
        let(:person_repository_response) { [] }

        it 'should return an empty array' do
          expect(JSON.parse(response.body, symbolize_names: true)).to match(
            array_including(
              a_hash_including(
                id: participant.id,
                first_name: participant.first_name,
                last_name: participant.last_name,
                relationships: []
              )
            )
          )
        end
      end

      context 'the participant has people search results, which are missing relationships' do
        let(:person_repository_response) { [{ _source: { id: participant.person_id } }] }

        it 'should return an empty array' do
          expect(JSON.parse(response.body, symbolize_names: true)).to match(
            array_including(
              a_hash_including(
                id: participant.id,
                first_name: participant.first_name,
                last_name: participant.last_name,
                relationships: []
              )
            )
          )
        end
      end

      context 'the participant has relationships from the people search' do
        let(:person_repository_response) do
          [
            { _source:
              {
                id: participant.person_id,
                relationships: [{ related_person_id: 'rel_1_id' }]
              } }
          ]
        end

        it 'should return an empty array' do
          expect(JSON.parse(response.body, symbolize_names: true)).to match(
            array_including(
              a_hash_including(
                id: participant.id,
                first_name: participant.first_name,
                last_name: participant.last_name,
                relationships: [{ related_person_id: 'rel_1_id' }]
              )
            )
          )
        end
      end
    end

    context 'there are two participants with people ids' do
      before do
        expect(PersonRepository).to receive(:find).with(array_including([person1.id, person2.id]))
          .and_return(person_repository_response)
        get relationships_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
      end

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

      let(:person_repository_response) do
        [
          { _source:
            {
              id: participant1.person_id,
              relationships: [{ related_person_id: 'rel_1_id' }]
            } },
          { _source:
            {
              id: participant2.person_id,
              relationships:
              [
                { related_person_id: 'rel_2_id' },
                { related_person_id: 'rel_3_id' }
              ]
            } }
        ]
      end

      it 'should associate each person with the proper relationships' do
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
