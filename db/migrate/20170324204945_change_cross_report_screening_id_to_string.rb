class ChangeCrossReportScreeningIdToString < ActiveRecord::Migration[5.0]
  def up
    change_column :cross_reports, :id, :string
    change_column :cross_reports, :screening_id, :string, foreign_key: true
    add_foreign_key :cross_reports, :screenings, column: :screening_id
  end
  def down
    change_column :cross_reports, :id, 'integer USING CAST(id AS integer)'
    change_column :cross_reports, :screening_id, 'integer USING CAST(id AS integer)'
  end
end
