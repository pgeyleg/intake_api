class AddEthnicityToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :ethnicity, :json
  end
end
