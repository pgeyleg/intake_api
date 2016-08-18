# frozen_string_literal: true
class CreateAddress < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :person_id
      t.timestamps
    end
  end
end
