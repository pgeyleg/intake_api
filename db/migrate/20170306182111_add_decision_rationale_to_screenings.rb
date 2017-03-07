class AddDecisionRationaleToScreenings < ActiveRecord::Migration[5.0]
  def change
    add_column :screenings, :decision_rationale, :string
  end
end
