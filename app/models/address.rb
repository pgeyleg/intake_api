# frozen_string_literal: true

# Address model which represents the physical address of a person
class Address < ActiveRecord::Base
  has_paper_trail

  self.inheritance_column = nil
  belongs_to :person, optional: true
  belongs_to :participant, optional: true
  ADDRESS_TYPES = %w[Home School Work Placement Homeless Other].freeze
end
