class AddIncidentCountyToReferrals < ActiveRecord::Migration[5.0]
  def change
    add_column :referrals, :incident_county, :string
  end
end
