# frozen_string_literal: true

# Screening Person model which represents
# the join model between screening and person
class ScreeningPerson < ActiveRecord::Base
  belongs_to :screening
  belongs_to :person
end
