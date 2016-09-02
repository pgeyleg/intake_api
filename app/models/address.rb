# frozen_string_literal: true
# Address model which represents the physical address of a person
class Address < ActiveRecord::Base
  belongs_to :person, optional: true
end
