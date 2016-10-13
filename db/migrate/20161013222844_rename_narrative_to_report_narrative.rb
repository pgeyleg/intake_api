class RenameNarrativeToReportNarrative < ActiveRecord::Migration[5.0]
  def change
    rename_column :screenings, :narrative, :report_narrative
  end
end
