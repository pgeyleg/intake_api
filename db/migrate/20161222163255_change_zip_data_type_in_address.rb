class ChangeZipDataTypeInAddress < ActiveRecord::Migration[5.0]
  def change
    change_column :addresses, :zip, :string
  end
end
