class CreateParticipantAddressJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :participant_addresses do |t|
      t.belongs_to :participant, index: true
      t.belongs_to :address, index: true
      t.timestamps
    end
    change_column :participant_addresses, :id, :string
    change_column :participant_addresses, :participant_id, :string
    change_column :participant_addresses, :address_id, :string
  end
end
