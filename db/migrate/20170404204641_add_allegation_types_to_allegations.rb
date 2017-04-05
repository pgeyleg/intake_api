class AddAllegationTypesToAllegations < ActiveRecord::Migration[5.0]
  def change
    add_column :allegations, :allegation_types, :string, array: true, required: true
  end
end
