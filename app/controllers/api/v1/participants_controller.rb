# frozen_string_literal: true

module Api
  module V1
    class ParticipantsController < ApplicationController # :nodoc:
      def create
        participant = Participant.new(participant_params)
        participant.addresses.build(addresses_params[:addresses])
        participant.save!
        render json: participant, status: :created
      end

      def update
        participant = Participant.find(participant_params[:id])
        participant.update_attributes!(participant_params)
        participant.participant_addresses = update_addresses(participant)
        participant.save!
        render json: ParticipantSerializer.new(participant)
          .as_json(include: %w(addresses address)), status: :ok
      end

      def destroy
        participant = Participant.find(params[:id])
        participant.destroy
      end

      private

      def addresses_params
        params.permit(
          addresses: [
            :id,
            :street_address,
            :city,
            :state,
            :zip,
            :type
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
          :person_id,
          :screening_id,
          :ssn
        )
      end

      def update_addresses(participant)
        addresses_params[:addresses].map do |address_attr|
          participant_address = participant
                                .participant_addresses
                                .find_or_initialize_by(address_id: address_attr[:id])

          if participant_address.persisted?
            person_address.address.update!(address_attr)
          else
            participant_address.build_address(address_attr)
          end

          participant_address
        end
      end
    end
  end
end
