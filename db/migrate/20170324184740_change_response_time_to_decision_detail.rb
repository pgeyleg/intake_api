class ChangeResponseTimeToDecisionDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :screenings, :screening_decision_detail, :string
    remove_column :screenings, :response_time
  end
end
