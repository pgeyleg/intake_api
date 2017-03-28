class RenameDecisionRationaleToAdditionalInformation < ActiveRecord::Migration[5.0]
  def change
    rename_column :screenings, :decision_rationale, :additional_information
  end
end
