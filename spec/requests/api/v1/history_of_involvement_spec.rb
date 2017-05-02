# frozen_string_literal: true
require 'rails_helper'

describe 'History of Allegations API', skip_auth: true do
  describe 'GET /api/v1/history_of_involvement' do
    let(:lana) { FactoryGirl.create :person }
    let(:archer) { FactoryGirl.create :person }
    let(:cyril) { FactoryGirl.create :person }
    let!(:current_screening) { FactoryGirl.create :screening }

    context 'there are no participants on the screening' do
      it 'returns an empty array' do
        get history_of_involvements_api_v1_screening_path(id: current_screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'there are participants on the current screening' do
      let!(:lana_current_participant) do
        FactoryGirl.create :participant,
          screening: current_screening,
          person: lana
      end
      let!(:archer_current_participant) do
        FactoryGirl.create :participant,
          screening: current_screening,
          person: archer
      end

      it 'returns an empty set when no old screenings exist for the screening participants' do
        get history_of_involvements_api_v1_screening_path(id: current_screening.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end

      context 'and there are one or more old screenings for the participants' do
        let(:old_screening) { FactoryGirl.create :screening }
        let!(:lana_old_participant) do
          FactoryGirl.create :participant,
            screening: old_screening,
            person: lana,
            first_name: 'Lana',
            last_name: 'Kane'
        end

        it 'returns the old screening, but not the current screening' do
          get history_of_involvements_api_v1_screening_path(id: current_screening.id)
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body).length).to eq(1)
        end

        context 'and those participants have shared history' do
          let!(:archer_old_participant) do
            FactoryGirl.create :participant,
              screening: old_screening,
              person: archer
          end
          let!(:old_allegation) do
            FactoryGirl.create :allegation,
              screening: old_screening,
              victim_id: lana_old_participant.id,
              perpetrator_id: archer_old_participant.id
          end

          it 'does not include duplicate screenings in the response' do
            get history_of_involvements_api_v1_screening_path(id: current_screening.id)
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body).length).to eq(1)
          end

          it 'includes participants and allegations in the response' do
            get history_of_involvements_api_v1_screening_path(id: current_screening.id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body).map(&:deep_symbolize_keys)
            expect(body).to match array_including(
              a_hash_including(
                id: old_screening.id,
                participants: array_including(
                  a_hash_including(
                    id: lana_old_participant.id,
                    first_name: 'Lana',
                    last_name: 'Kane',
                    roles: []
                  ),
                  a_hash_including(
                    id: archer_old_participant.id,
                    roles: []
                  )
                ),
                allegations: array_including(
                  a_hash_including(
                    id: old_allegation.id
                  )
                )
              )
            )
          end

          context 'and those participants have multiple separate histories' do
            before do
              5.times { FactoryGirl.create :participant, person: lana }
              5.times { FactoryGirl.create :participant, person: archer }
              5.times { FactoryGirl.create :participant, person: cyril }
            end

            it 'returns all possible screenings' do
              get history_of_involvements_api_v1_screening_path(id: current_screening.id)
              expect(response.status).to eq(200)
              expect(JSON.parse(response.body).length).to eq(11)
            end
          end
        end
      end
    end
  end
end
