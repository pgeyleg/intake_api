# frozen_string_literal: true

# PeopleSearchController is the controller responsible for accessing People ES index
module Api
  module V2
    class PeopleSearchController < ApplicationController # :nodoc:
      include AuthenticationConcern

      def index
        people_search = PeopleSearchQueryFormatter.new(params[:search_term]).format_query
        response = TPT.make_api_call(security_token, people_search_path, :post, people_search)
        people = response.body.deep_stringify_keys['hits']['hits'].map do |document|
          redacted_person_with_highlights document
        end
        render json: people
      end

      private

      def redacted_person_with_highlights(document)
        redact_ssn(person_with_highlights(document))
      end

      def people_search_path
        Rails.configuration.intake_api[:people_search_path]
      end

      def security_token
        request.headers['Authorization']
      end

      def person_with_highlights(document)
        highlight = {}
        if document['highlight']
          highlight = document['highlight'].each_with_object({}) do |(k, v), memo|
            memo[k] = v.first
            memo
          end
        end
        document['_source'].merge(highlight: highlight)
      end

      def redact_ssn(document)
        allowable_ssn_chars = 4
        ssn = document.stringify_keys['ssn']
        highlight = document.stringify_keys['highlight']
        document['ssn'] = ssn.gsub(/.(?=.{#{allowable_ssn_chars}})/, '') if ssn
        if highlight && highlight['ssn']
          highlight['ssn'] =
            "<em>#{highlight['ssn'][4..-6].gsub(/.(?=.{#{allowable_ssn_chars}})/, '')}</em>"
        end
        document
      end
    end
  end
end
