class RenamePhoneNumberFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :phone_numbers, :phone_number, :number
    rename_column :phone_numbers, :phone_number_type, :type
  end
end
