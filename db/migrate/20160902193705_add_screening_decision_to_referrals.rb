class AddScreeningDecisionToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :screening_decision, :string
  end
end
