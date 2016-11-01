class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.date :date_of_birth
      t.string :first_name
      t.string :gender
      t.string :last_name
      t.string :ssn
      t.belongs_to :screening, index: true
      t.belongs_to :person, index: true
      t.timestamps
    end
  end
end
