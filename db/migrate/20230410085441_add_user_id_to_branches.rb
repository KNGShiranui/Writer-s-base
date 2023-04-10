class AddUserIdToBranches < ActiveRecord::Migration[6.1]
  def change
    add_reference :branches, :user, foreign_key: true, default: 2
  end
end
