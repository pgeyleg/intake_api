# frozen_string_literal: true

require 'rails_helper'

describe 'Screening Allegations API', skip_auth: true do
  describe 'PUT /api/v1/screenings/:id' do
    it 'adds an allegation if one did not exist before' do
      screening = Screening.create!
      address = ScreeningAddress.create!(
        screening: screening,
        address: Address.create!(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )
      bart = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson',
        roles: ['Victim']
      )
      lisa = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson',
        roles: ['Perpetrator']
      )

      updated_params = {
        address: {
          id: address.address_id
        },
        allegations: [
          FactoryGirl.build(:allegation,
            screening_id: screening.id,
            perpetrator_id: bart.id,
            victim_id: lisa.id).attributes
        ]
      }

      expect do
        put "/api/v1/screenings/#{screening.id}", params: updated_params
      end.to change(Allegation, :count).by(1)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        id: screening.id,
        participants: array_including(
          a_hash_including(
            id: bart.id,
            first_name: 'Bart',
            last_name: 'Simpson'
          ),
          a_hash_including(
            id: lisa.id,
            first_name: 'Lisa',
            last_name: 'Simpson'
          )
        ), allegations: array_including(
          a_hash_including(
            screening_id: screening.id,
            perpetrator_id: bart.id,
            victim_id: lisa.id
          )
        )
      )
    end

    it 'does nothing if an existing allegation has not changed' do
      screening = Screening.create!
      address = ScreeningAddress.create!(
        screening: screening,
        address: Address.create!(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )
      bart = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson',
        roles: ['Victim']
      )
      lisa = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson',
        roles: ['Perpetrator']
      )
      allegation = FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: bart.id,
        victim_id: bart.id)

      updated_params = {
        address: {
          id: address.address_id
        },
        allegations: [
          allegation.attributes.merge('victim_id' => lisa.id)
        ]
      }

      expect do
        put "/api/v1/screenings/#{screening.id}", params: updated_params
      end.to change(Allegation, :count).by(0)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        id: screening.id,
        participants: array_including(
          a_hash_including(
            id: bart.id,
            first_name: 'Bart',
            last_name: 'Simpson'
          ),
          a_hash_including(
            id: lisa.id,
            first_name: 'Lisa',
            last_name: 'Simpson'
          )
        ), allegations: array_including(
          a_hash_including(
            screening_id: screening.id,
            perpetrator_id: bart.id,
            victim_id: lisa.id
          )
        )
      )
    end

    it 'deletes allegations that have been removed from the set' do
      screening = Screening.create!
      address = ScreeningAddress.create!(
        screening: screening,
        address: Address.create!(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )
      bart = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson',
        roles: ['Victim']
      )
      lisa = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson',
        roles: ['Perpetrator']
      )
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: bart.id,
        victim_id: bart.id)
      updated_params = {
        address: {
          id: address.address_id
        },
        allegations: []
      }

      expect do
        put "/api/v1/screenings/#{screening.id}", params: updated_params
      end.to change(Allegation, :count).by(-1)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        id: screening.id,
        participants: array_including(
          a_hash_including(
            id: bart.id,
            first_name: 'Bart',
            last_name: 'Simpson'
          ),
          a_hash_including(
            id: lisa.id,
            first_name: 'Lisa',
            last_name: 'Simpson'
          )
        ), allegations: []
      )
    end
  end
end
