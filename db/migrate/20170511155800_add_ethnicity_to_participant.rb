class AddEthnicityToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :ethnicity, :json
  end
end
