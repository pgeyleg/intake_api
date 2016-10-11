class RenameReferralsToScreenings < ActiveRecord::Migration[5.0]
  def change
    rename_table :referrals, :screenings
    rename_column :referral_addresses, :referral_id, :screening_id
    rename_column :referral_people, :referral_id, :screening_id
  end
end
