class CreateReferralPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :referral_people do |t|
      t.belongs_to :referral, index: true
      t.belongs_to :person, index: true
      t.timestamps
    end
  end
end
