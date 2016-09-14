class AddNarrativeToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :narrative, :text
  end
end
