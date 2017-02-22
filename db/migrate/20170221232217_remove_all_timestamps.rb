class RemoveAllTimestamps < ActiveRecord::Migration[5.0]
  def change
    [ :addresses,
      :participant_addresses,
      :participants,
      :people,
      :person_addresses,
      :person_phone_numbers,
      :phone_numbers,
      :screening_addresses,
      :screenings,
    ].each do |table|
      remove_column table, :updated_at, :datetime, null: false
      remove_column table, :created_at, :datetime, null: false
    end
  end
end
