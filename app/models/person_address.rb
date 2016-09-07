# frozen_string_literal: true

# Person Address model which represents
# the join model between person and address
class PersonAddress < ActiveRecord::Base
  belongs_to :person
  belongs_to :address
end