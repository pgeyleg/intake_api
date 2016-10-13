# frozen_string_literal: true

# ScreeningsRepo is the Repository object for accessing Screenings ES index
class ScreeningsRepo
  include Elasticsearch::Persistence::Repository

  def initialize(options = {})
    index options[:index] || 'screenings'
    es_host = if Rails.env.test?
                ENV['TEST_ELASTICSEARCH_URL']
              else
                ENV['ELASTICSEARCH_URL']
              end
    client Elasticsearch::Client.new(host: es_host)
  end

  klass Screening

  settings do
    mappings dynamic: 'strict' do
      indexes :id
      indexes :created_at
      indexes :updated_at
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
    end
  end

  def serialize(document)
    document.attributes
  end

  def deserialize(document)
    document['_source']
  end
end
