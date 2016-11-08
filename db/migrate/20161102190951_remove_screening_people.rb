class RemoveScreeningPeople < ActiveRecord::Migration[5.0]
  def change
    drop_table :screening_people
  end
end
