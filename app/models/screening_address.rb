# frozen_string_literal: true

# Screening Address model which represents
# the join model between screening and address
class ScreeningAddress < ActiveRecord::Base
  has_paper_trail

  belongs_to :screening
  belongs_to :address
end
