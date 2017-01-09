class AddRacesToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :races, :json
  end
end
