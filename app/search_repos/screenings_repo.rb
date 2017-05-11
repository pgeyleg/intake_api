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
      indexes :additional_information
      indexes :ended_at
      indexes :incident_county
      indexes :incident_date
      indexes :location_type
      indexes :communication_method
      indexes :name
      indexes :report_narrative
      indexes :reference
      indexes :screening_decision_detail
      indexes :screening_decision
      indexes :started_at
      indexes :assignee
      indexes :safety_information
      indexes :safety_alerts
    end
  end

  def serialize(document)
    document.attributes
  end

  def deserialize(document)
    document['_source']
  end

  def self.search_es_by(screening_decision_details, screening_decisions)
    search(query(screening_decision_details, screening_decisions), size: 100)
  end

  def self.query(screening_decision_details, screening_decisions)
    terms = []
    if screening_decision_details
      terms << { terms: { screening_decision_detail: screening_decision_details } }
    end
    terms << { terms: { screening_decision: screening_decisions } } if screening_decisions
    { query: { filtered: { filter: { bool: { must: terms } } } } }
  end
end
