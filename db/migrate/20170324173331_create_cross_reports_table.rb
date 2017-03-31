# frozen_string_literal: true

class CreateCrossReportsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :cross_reports do |t|
      t.string :agency_name
      t.string :agency_type
      t.belongs_to :screening, index: true
      t.timestamps
    end
  end
end
