# frozen_string_literal: true

# PhoneNumber model which represents a phone number
class PhoneNumber < ActiveRecord::Base
   PHONE_NUMBER_TYPES = %w(Cell Home Work Other)
   validates :phone_number_type,
     inclusion: { in: PHONE_NUMBER_TYPES, allow_nil: true }
end
