# frozen_string_literal: true

require 'rails_helper'

describe 'History of Involvement API', skip_auth: true do
  describe 'GET /api/v1/history_of_involvement' do
    let(:screening) { FactoryGirl.create :screening }

    context 'no participants in the screening' do
      it 'should return an empty array' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'no participants on the screening have people ids' do
      let!(:participant) { FactoryGirl.create :participant, screening: screening }

      it 'should return an empty array' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
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
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
      end

      context 'one participant with a person id has no people search results' do
        let(:person_repository_response) { [] }

        it 'should return an empty array' do
          expect(JSON.parse(response.body)).to eq([])
        end
      end

      context 'screenings is missing from the person repository response' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant.id
              }
            }
          ]
        end

        it 'returns an empty array' do
          expect(JSON.parse(response.body, symbolize_names: true)).to eq([])
        end
      end

      context 'one participant has no screening history' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant.id,
                screenings: []
              }
            }
          ]
        end

        it 'returns an empty array' do
          expect(JSON.parse(response.body, symbolize_names: true)).to eq([])
        end
      end

      context 'one participant has one screening history' do
        let(:screenings) { [{ id: '123456789' }] }
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant.id,
                screenings: screenings
              }
            }
          ]
        end

        it 'should return the relevant screening information' do
          expect(JSON.parse(response.body, symbolize_names: true))
            .to match array_including(screenings)
        end
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

      before do
        expect(PersonRepository).to receive(:find).with(array_including(person1.id, person2.id))
          .and_return(person_repository_response)
        get history_of_involvements_api_v1_screening_path(id: screening.id)
        expect(response.status).to eq(200)
      end

      context 'two participants have different screenings' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant1.id,
                screenings: [{ id: '123456789' }]
              }
            },
            {
              _source: {
                id: participant2.id,
                screenings: [{ id: '987654321' }]
              }
            }
          ]
        end
        let(:screenings) { [{ id: '123456789' }, { id: '987654321' }] }

        it 'should return the relevant screening information' do
          expect(JSON.parse(response.body, symbolize_names: true))
            .to match array_including(screenings)
        end
      end

      context 'two participants share a screening' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant1.id,
                screenings: [{ id: '123456789' }, { id: '456789123' }]
              }
            },
            {
              _source: {
                id: participant2.id,
                screenings: [{ id: '987654321' }, { id: '456789123' }]
              }
            }
          ]
        end
        let(:screenings) { [{ id: '123456789' }, { id: '987654321' }, { id: '456789123' }] }

        it 'should return the relevant screening information' do
          expect(JSON.parse(response.body, symbolize_names: true))
            .to match array_including(screenings)
        end
      end

      context 'two participants are present, one with screenings and one without' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant1.id,
                screenings: [{ id: '123456789' }, { id: '456789123' }]
              }
            },
            {
              _source: {
                id: participant2.id,
                screenings: []
              }
            }
          ]
        end
        let(:screenings) { [{ id: '123456789' }, { id: '456789123' }] }

        it 'should return the relevant screening information' do
          expect(JSON.parse(response.body, symbolize_names: true))
            .to match array_including(screenings)
        end
      end

      context 'two participants are present, one has no screenings in the search response' do
        let(:person_repository_response) do
          [
            {
              _source: {
                id: participant1.id,
                screenings: [{ id: '123456789' }, { id: '456789123' }]
              }
            },
            {
              _source: {
                id: participant2.id
              }
            }
          ]
        end
        let(:screenings) { [{ id: '123456789' }, { id: '456789123' }] }

        it 'should return the relevant screening information' do
          expect(JSON.parse(response.body, symbolize_names: true))
            .to match array_including(screenings)
        end
      end
    end
  end
end
