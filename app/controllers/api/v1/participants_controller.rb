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

      def destroy
        participant = Participant.find(params[:id])
        participant.destroy
      end

      private

      def addresses_params
        params.permit(
          addresses: [
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
          :date_of_birth,
          :first_name,
          :gender,
          :last_name,
          :person_id,
          :screening_id,
          :ssn
        )
      end
    end
  end
end
