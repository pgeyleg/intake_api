class CreateParticipantPhoneNumberJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :participant_phone_numbers do |t|
      t.belongs_to :participant, index: true
      t.belongs_to :phone_number, index: true
      t.timestamps
    end
    change_column :participant_phone_numbers, :id, :string
    change_column :participant_phone_numbers, :participant_id, :string
    change_column :participant_phone_numbers, :phone_number_id, :string
  end
end
