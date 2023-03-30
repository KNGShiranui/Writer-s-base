class AddNullConstraintToUserIdInIssues < ActiveRecord::Migration[6.1]
  def change
    change_column_null :issues, :user_id, false
  end
end
