# frozen_string_literal: true
class AddReferralFields < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_column :referrals, :ended_at, :datetime
    add_column :referrals, :incident_date, :date
    add_column :referrals, :location_type, :string
    add_column :referrals, :method_of_referral, :string
    add_column :referrals, :name, :string
    add_column :referrals, :started_at, :datetime

    create_table :referral_addresses do |t|
      t.belongs_to :referral, index: true
      t.belongs_to :address, index: true
      t.timestamps
    end
  end
end
