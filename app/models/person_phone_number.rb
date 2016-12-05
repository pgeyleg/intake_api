# frozen_string_literal: true

# Person Phone Number model which represents
# the join model between person and phone number
class PersonPhoneNumber < ActiveRecord::Base
  belongs_to :person
  belongs_to :phone_number
end
