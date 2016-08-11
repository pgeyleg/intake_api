# frozen_string_literal: true

class AddGenderSsnDobToPerson < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_column :people, :gender, :string
    add_column :people, :ssn, :string
    add_column :people, :date_of_birth, :date
  end
end
