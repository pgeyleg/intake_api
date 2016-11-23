class AddMiddleNameAndSuffixToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :middle_name, :string
    add_column :people, :name_suffix, :string
  end
end
