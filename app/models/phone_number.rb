# frozen_string_literal: true

# PhoneNumber model which represents a phone number
class PhoneNumber < ActiveRecord::Base
  self.inheritance_column = nil
  PHONE_NUMBER_TYPES = %w(Cell Home Work Other)
  validates :type,
    inclusion: { in: PHONE_NUMBER_TYPES, allow_nil: true }
end
