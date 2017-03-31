# frozen_string_literal: true
# Allegation model
class Allegation < ActiveRecord::Base
  belongs_to :screening
end
