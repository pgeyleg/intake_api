class AddAssigneeToScreening < ActiveRecord::Migration[5.0]
  def change
    add_column :screenings, :assignee, :string
  end
end
