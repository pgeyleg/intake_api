class AddWorkerSafetyInformationToScreening < ActiveRecord::Migration[5.0]
  def change
    add_column :screenings, :safety_information, :text
    add_column :screenings, :safety_alerts, :string, array: true
  end
end
