# frozen_string_literal: true
class CreatePhoneNumber < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :phone_numbers do |t|
      t.string :phone_number
      t.string :phone_number_type
      t.timestamps
    end
    create_table :person_phone_numbers do |t|
      t.belongs_to :person, index: true
      t.belongs_to :phone_number, index: true
      t.timestamps
    end
  end
end
