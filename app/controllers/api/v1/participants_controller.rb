# frozen_string_literal: true

module Api
  module V1
    class ParticipantsController < ApplicationController # :nodoc:
      include AuthenticationConcern

      def create
        participant = Participant.new(participant_params)
        participant.addresses.build(addresses_params[:addresses])
        participant.phone_numbers.build(phone_numbers_params[:phone_numbers])
        participant.save!
        render json: participant, status: :created
      end

      def update
        participant = Participant.find(participant_params[:id])
        participant.update_attributes!(participant_params)
        participant.participant_addresses = update_addresses(participant)
        participant.participant_phone_numbers = update_phone_numbers(participant)
        participant.save!
        render json: ParticipantSerializer.new(participant)
          .as_json(include: %w[addresses address phone_numbers phone_number]), status: :ok
      end

      def destroy
        participant = Participant.find(params[:id])
        participant.destroy
      end

      private

      def phone_numbers_params
        params.permit(
          phone_numbers: %i[
            id
            number
            type
          ]
        )
      end

      def addresses_params
        params.permit(
          addresses: %i[
            id
            street_address
            city
            state
            zip
            type
          ]
        )
      end

      def participant_params
        params.permit(
          :id,
          :date_of_birth,
          :first_name,
          :gender,
          :last_name,
          :middle_name,
          :name_suffix,
          :person_id,
          :screening_id,
          :ssn,
          languages: [],
          races: %i[race race_detail],
          ethnicity: %i[hispanic_latino_origin ethnicity_detail],
          roles: []
        )
      end

      def update_addresses(participant)
        (addresses_params[:addresses] || []).map do |address_attr|
          participant_address = participant
                                .participant_addresses
                                .find_or_initialize_by(address_id: address_attr[:id])

          if participant_address.persisted?
            participant_address.address.update!(address_attr)
          else
            participant_address.build_address(address_attr)
          end

          participant_address
        end
      end

      def update_phone_numbers(participant)
        (phone_numbers_params[:phone_numbers] || []).map do |phonenumber_attr|
          participant_phone_number = participant
                                     .participant_phone_numbers
                                     .find_or_initialize_by(phone_number_id: phonenumber_attr[:id])
          if participant_phone_number.persisted?
            participant_phone_number.phone_number.update!(phonenumber_attr)
          else
            participant_phone_number.build_phone_number(phonenumber_attr)
          end
          participant_phone_number
        end
      end
    end
  end
end
