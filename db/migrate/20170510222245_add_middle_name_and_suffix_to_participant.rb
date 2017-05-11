class AddMiddleNameAndSuffixToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :middle_name, :string
    add_column :participants, :name_suffix, :string
  end
end
