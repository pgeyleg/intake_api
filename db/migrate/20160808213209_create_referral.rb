# frozen_string_literal: true

class CreateReferral < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :referrals do |t|
      t.string :reference
      t.timestamps
    end
  end
end
