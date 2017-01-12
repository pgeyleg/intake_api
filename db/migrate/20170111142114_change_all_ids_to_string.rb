class ChangeAllIdsToString < ActiveRecord::Migration[5.0]
  def up
    change_column :addresses, :id, :string
    change_column :participants, :id, :string
    change_column :participants, :screening_id, :string
    change_column :person_addresses, :id, :string
    change_column :person_addresses, :address_id, :string
    change_column :person_phone_numbers, :id, :string
    change_column :person_phone_numbers, :phone_number_id, :string
    change_column :phone_numbers, :id, :string
    change_column :screening_addresses, :id, :string
    change_column :screening_addresses, :screening_id, :string
    change_column :screening_addresses, :address_id, :string
    change_column :screenings, :id, :string
  end

  def down
    change_column :addresses, :id, 'integer USING CAST(id AS integer)'
    change_column :participants, :id, 'integer USING CAST(id AS integer)'
    change_column :participants, :screening_id, 'integer USING CAST(id AS integer)'
    change_column :person_addresses, :id, 'integer USING CAST(id AS integer)'
    change_column :person_addresses, :address_id, 'integer USING CAST(id AS integer)'
    change_column :person_phone_numbers, :id, 'integer USING CAST(id AS integer)'
    change_column :person_phone_numbers, :phone_number_id, 'integer USING CAST(id AS integer)'
    change_column :phone_numbers, :id, 'integer USING CAST(id AS integer)'
    change_column :screening_addresses, :id, 'integer USING CAST(id AS integer)'
    change_column :screening_addresses, :screening_id, 'integer USING CAST(id AS integer)'
    change_column :screening_addresses, :address_id, 'integer USING CAST(id AS integer)'
    change_column :screenings, :id, 'integer USING CAST(id AS integer)'
  end
end
