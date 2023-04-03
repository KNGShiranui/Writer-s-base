class RemoveDefaultFromUsersName < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :name, from: "", to: nil
  end
end
