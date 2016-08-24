# frozen_string_literal: true
class AddReferralFields < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_column :referrals, :city, :string
    add_column :referrals, :ended_at, :datetime
    add_column :referrals, :incident_date, :date
    add_column :referrals, :location_type, :string
    add_column :referrals, :method_of_referral, :string
    add_column :referrals, :name, :string
    add_column :referrals, :started_at, :datetime
    add_column :referrals, :state, :string
    add_column :referrals, :street_address, :string
    add_column :referrals, :zip, :integer
  end
end
