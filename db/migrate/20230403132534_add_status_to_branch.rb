class AddStatusToBranch < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :status, :integer, default: 0, null: false
  end
end
