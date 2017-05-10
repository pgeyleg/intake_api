class AddRacesToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :races, :json
  end
end
