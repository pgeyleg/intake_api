# frozen_string_literal: true
# Person model which represents a real world person
class Person < ActiveRecord::Base
  has_one :address
end
