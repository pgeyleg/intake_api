class AddAllegations < ActiveRecord::Migration[5.0]
  def change
    create_table :allegations do |t|
      t.string :screening_id, index: true
      t.string :perpetrator_id
      t.string :victim_id
      t.timestamps
    end

    add_foreign_key :allegations, :screenings
    add_foreign_key :allegations, :participants, column: :perpetrator_id
    add_foreign_key :allegations, :participants, column: :victim_id
    add_index :allegations,
      [:screening_id, :perpetrator_id, :victim_id],
      unique: true,
      name: 'index_allegations_on_screening_perpetrator_victim'
  end
end
