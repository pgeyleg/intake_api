class ChangePersonIdToString < ActiveRecord::Migration[5.0]
  def up
    change_column :people, :id, :string

    change_column :participants, :person_id, :string
    change_column :person_addresses, :person_id, :string
    change_column :person_phone_numbers, :person_id, :string
  end

  def down
    change_column :people, :id, 'integer USING CAST(id AS integer)'

    change_column :participants, :person_id, 'integer USING CAST(person_id AS integer)'
    change_column :person_addresses, :person_id, 'integer USING CAST(person_id AS integer)'
    change_column :person_phone_numbers, :person_id, 'integer USING CAST(person_id AS integer)'
  end
end
