# frozen_string_literal: true

# Participant model which represents a real world
# person on a screening
class Participant < ActiveRecord::Base
  belongs_to :screening
  belongs_to :person
end
