class AddRolesToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :roles, :string, array: true, default: []
  end
end
