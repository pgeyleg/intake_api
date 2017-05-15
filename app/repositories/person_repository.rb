# frozen_string_literal: true

class PersonRepository # :nodoc:
  def self.find(ids)
    ids_as_array = ids.is_a?(Array) ? ids : [ids]
    people_search_path = Rails.configuration.intake_api[:people_search_path]
    response = TPT.make_api_call(nil, people_search_path, :post, search_query(ids_as_array))
    response.body.deep_symbolize_keys[:hits][:hits].map { |result| result[:_source] }.try(:flatten)
  end

  class << self
    private

    def search_query(ids)
      id_query_criteria = ids.join(' || ')
      {
        query: {
          bool: {
            must: [
              {
                match: {
                  id: id_query_criteria
                }
              }
            ]
          }
        },
        _source: fields
      }
    end

    def fields
      %w[id relationships screenings]
    end
  end
end
