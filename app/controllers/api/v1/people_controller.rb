# frozen_string_literal: true

module Api
  module V1
    class PeopleController < ApplicationController # :nodoc:
      def create
        person = Person.new(person_params)
        person.build_person_address
        person.person_address.build_address(address_params)
        person.phone_numbers.build(phone_numbers_params[:phone_numbers])
        person.save!
        render json: person, status: :created
      end

      def update
        person = Person.find(params[:id])
        person.update_attributes!(person_params)
        person.address.update_attributes!(address_params)
        person.person_phone_numbers = update_phone_numbers(person)
        person.save!
        render json: person, status: :ok
      end

      def show
        person = Person.find(params[:id])
        render json: person, status: :ok
      end

      def destroy
        person = Person.find(params[:id])
        person.destroy
        head :no_content
      end

      private

      def address_params
        params.require(:address).permit(
          :id,
          :street_address,
          :city,
          :state,
          :zip
        )
      end

      def person_params
        params.permit(
          :first_name,
          :middle_name,
          :last_name,
          :name_suffix,
          :gender,
          :date_of_birth,
          :ssn,
          languages: []
        )
      end

      def phone_numbers_params
        params.permit(
          phone_numbers: [
            :id,
            :number,
            :type
          ]
        )
      end

      def update_phone_numbers(person)
        phone_numbers_params[:phone_numbers].map do |phone_number_attrs|
          person_phone_join_model = person
                                    .person_phone_numbers
                                    .find_or_initialize_by(phone_number_id: phone_number_attrs[:id])

          if person_phone_join_model.persisted?
            person_phone_join_model.phone_number.update!(phone_number_attrs)
          else
            person_phone_join_model.build_phone_number(phone_number_attrs)
          end
          person_phone_join_model
        end
      end
    end
  end
end
