class AddProgressToIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :progress, :boolean, default: true
  end
end
