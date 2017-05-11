class AddLanguagesToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :languages, :string, array: true, default: '{}'
  end
end
