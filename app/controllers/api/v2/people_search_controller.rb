# frozen_string_literal: true

# PeopleSearchController is the controller responsible for accessing People ES index
module Api
  module V2
    class PeopleSearchController < ApplicationController # :nodoc:
      include AuthenticationConcern

      PEOPLE_SEARCH_PATH = '/api/v1/dora/people/_search'
      def index
        people_search = PeopleSearchQueryFormatter.new(params[:search_term]).format_query
        response = API.make_api_call(PEOPLE_SEARCH_PATH, :post, people_search)
        people = response.body['hits']['hits'].map do |document|
          person_with_highlights(document)
        end
        render json: people
      end

      private

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
