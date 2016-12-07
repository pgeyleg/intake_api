class AddLanguagesToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :languages, :string, array: true, default: '{}'
  end
end
