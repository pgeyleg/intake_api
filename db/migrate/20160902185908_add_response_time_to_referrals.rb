class AddResponseTimeToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :response_time, :string
  end
end
