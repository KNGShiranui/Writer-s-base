class AddStatusAndPriorityToRepository < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :status, :integer, null: false, default: 0
    add_column :repositories, :priority, :integer, null: false, default: 0
  end
end
