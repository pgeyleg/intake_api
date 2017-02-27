# frozen_string_literal: true
require "#{Rails.root}/lib/elasticsearch_wrapper"

# ScreeningsRepo is the Repository object for accessing Screenings ES index
class ScreeningsRepo
  include Elasticsearch::Persistence::Repository

  def initialize(options = {})
    index options[:index] || 'screenings'
    client ::ElasticsearchWrapper.client
  end

  klass Screening

  settings do
    mappings dynamic: 'strict' do
      indexes :id
      indexes :ended_at
      indexes :incident_county
      indexes :incident_date
      indexes :location_type
      indexes :communication_method
      indexes :name
      indexes :report_narrative
      indexes :reference
      indexes :response_time
      indexes :screening_decision
      indexes :started_at
      indexes :assignee
    end
  end

  def serialize(document)
    document.attributes
  end

  def deserialize(document)
    document['_source']
  end

  def self.search_es_by(response_times, screening_decisions)
    search(query(response_times, screening_decisions))
  end

  def self.query(response_times, screening_decisions)
    terms = []
    terms << { terms: { response_time: response_times } } if response_times
    terms << { terms: { screening_decision: screening_decisions } } if screening_decisions
    { query: { filtered: { filter: { bool: { must: terms } } } } }
  end
end
