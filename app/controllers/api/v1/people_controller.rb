# frozen_string_literal: true

module Api
  module V1
    class PeopleController < ApplicationController # :nodoc:
      def create
        person = Person.new(person_params)
        person.addresses.build(addresses_params[:addresses])
        person.phone_numbers.build(phone_numbers_params[:phone_numbers])
        person.save!
        render json: person, status: :created
      end

      def update
        person = Person.find(params[:id])
        person.update_attributes!(person_params)
        person.person_addresses = update_addresses(person)
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

      def person_params
        params.permit(
          :first_name,
          :middle_name,
          :last_name,
          :name_suffix,
          :gender,
          :date_of_birth,
          :ssn,
          languages: [],
          races: []
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

      def update_addresses(person)
        addresses_params[:addresses].map do |address_attr|
          person_address_join_model = person
                                      .person_addresses
                                      .find_or_initialize_by(address_id: address_attr[:id])

          if person_address_join_model.persisted?
            person_address_join_model.address.update!(address_attr)
          else
            person_address_join_model.build_address(address_attr)
          end
          person_address_join_model
        end
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
