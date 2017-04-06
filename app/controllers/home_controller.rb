# frozen_string_literal: true
class HomeController < ApplicationController # :nodoc:
  def index
    render plain: 'Intake API'
  end
end
