# frozen_string_literal: true

# ReferralsRepo is the Repository object for accessing Referrals ES index
class ReferralsRepo
  include Elasticsearch::Persistence::Repository

  def initialize(options = {})
    index options[:index] || 'referrals'
    es_host = if Rails.env.test?
                ENV['TEST_ELASTICSEARCH_URL']
              else
                ENV['ELASTICSEARCH_URL']
              end
    client Elasticsearch::Client.new(host: es_host)
  end

  klass Referral

  settings do
    mappings dynamic: 'strict' do
      indexes :id
      indexes :created_at
      indexes :updated_at
      indexes :ended_at
      indexes :incident_county
      indexes :incident_date
      indexes :location_type
      indexes :method_of_referral
      indexes :name
      indexes :narrative
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
