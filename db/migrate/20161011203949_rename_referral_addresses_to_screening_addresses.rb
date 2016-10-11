class RenameReferralAddressesToScreeningAddresses < ActiveRecord::Migration[5.0]
  def change
    rename_table :referral_addresses, :screening_addresses
  end
end
