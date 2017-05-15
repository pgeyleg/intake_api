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
          person_with_highlights(document)
        end
        render json: people
      end

      private

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
    end
  end
end
