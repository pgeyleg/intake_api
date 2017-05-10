# frozen_string_literal: true

require 'rails_helper'

describe Screening do
  it { is_expected.to be_versioned }

  with_versioning do
    it 'tracks changes made to screenings' do
      screening = create :screening
      expect(screening.versions.count).to eq(1)
      screening.update_attributes(name: 'Best screening EVAR')
      expect(screening.versions.count).to eq(2)
    end
  end

  describe '.people_ids' do
    let(:screening) { FactoryGirl.create :screening }
    let!(:part1) { FactoryGirl.create :participant, screening: screening }
    let!(:part2) do
      FactoryGirl.create :participant,
        screening: screening,
        person: FactoryGirl.create(:person)
    end
    let!(:part3) do
      FactoryGirl.create :participant,
        screening: screening,
        person: FactoryGirl.create(:person)
    end

    it 'returns the person ids of all participants on the screening, with no nil values' do
      expect(screening.people_ids).to contain_exactly(part2.person_id, part3.person_id)
    end
  end

  describe '.participants_with_relationships' do
    let(:screening) { FactoryGirl.create :screening }

    context 'no participants on the screening' do
      it 'should return an empty array' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        participants = screening.participants_with_relationships
        expect(participants).to eq([])
      end
    end

    context 'one participant on the screening without a person id' do
      let!(:participant) do
        FactoryGirl.create(
          :participant,
          screening: screening
        )
      end

      it 'should set relationships to an empty array for the participant' do
        expect(PersonRepository).to_not receive(:find).with(anything)
        participants = screening.participants_with_relationships
        expect(participants).to contain_exactly(participant)
        expect(participants.first.relationships).to eq([])
      end
    end

    context 'one participant on the screening with a person id' do
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
      end

      context 'the participant has no people search results' do
        let(:person_repository_response) { [] }

        it 'should set relationships to an empty array for the participant' do
          participants = screening.participants_with_relationships
          expect(participants).to contain_exactly(participant)
          expect(participants.first.relationships).to eq([])
        end
      end

      context 'the participant has people search results, which are missing relationships' do
        let(:person_repository_response) { [{ id: participant.person_id }] }

        it 'should set relationships to an empty array for the participant' do
          participants = screening.participants_with_relationships
          expect(participants).to contain_exactly(participant)
          expect(participants.first.relationships).to eq([])
        end
      end

      context 'the participant has relationships from the people search' do
        let(:person_repository_response) do
          [
            {
              id: participant.person_id,
              relationships: [{ related_person_id: 'rel_1_id' }]
            }
          ]
        end

        it 'should set relationships for the participant' do
          participants = screening.participants_with_relationships
          expect(participants).to contain_exactly(participant)
          expect(participants.first.relationships).to eq([{ related_person_id: 'rel_1_id' }])
        end
      end
    end

    context 'two participants with people ids on the screening' do
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
          {
            id: participant1.person_id,
            relationships: [{ related_person_id: 'rel_1_id' }]
          },
          {
            id: participant2.person_id,
            relationships:
            [
              { related_person_id: 'rel_2_id' },
              { related_person_id: 'rel_3_id' }
            ]
          }
        ]
      end

      before do
        expect(PersonRepository).to receive(:find).with(array_including([person1.id, person2.id]))
          .and_return(person_repository_response)
      end

      it 'should set relationships for both participants' do
        participants = screening.participants_with_relationships
        expect(participants).to contain_exactly(participant1, participant2)
        expect(participants.find { |p| p.id == participant1.id }.relationships).to eq(
          [
            { related_person_id: 'rel_1_id' }
          ]
        )
        expect(participants.find { |p| p.id == participant2.id }.relationships).to eq(
          [
            { related_person_id: 'rel_2_id' },
            { related_person_id: 'rel_3_id' }
          ]
        )
      end
    end
  end
end
