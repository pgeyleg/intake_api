class RenameMethodOfReferralToCommunicationMethod < ActiveRecord::Migration[5.0]
  def change
    rename_column :screenings, :method_of_referral, :communication_method
  end
end
