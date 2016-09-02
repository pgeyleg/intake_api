# frozen_string_literal: true
class RemovePersonIdFromAddress < ActiveRecord::Migration[5.0]
  def change
    remove_column :addresses, :person_id, :integer
    create_table :person_addresses do |t|
      t.belongs_to :person, index: true
      t.belongs_to :address, index: true
      t.timestamps
    end
  end
end
