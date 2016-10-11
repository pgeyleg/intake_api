class ReferralPeopleToScreeningPeople < ActiveRecord::Migration[5.0]
  def change
    rename_table :referral_people, :screening_people
  end
end
