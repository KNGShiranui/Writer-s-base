class ChangeColumnTypeInIssue < ActiveRecord::Migration[6.1]
  def up
    # 文字列のステータスを整数にマッピング
    status_mapping = {
      'open' => 0,
      'semi-open' => 1,
      'closed' => 2,
      # 他のステータスがあればここにマッピングを追加
    }

    # ステータスを一時的なカラムにコピー
    add_column :issues, :new_status, :integer

    # ステータスを整数に変換
    Issue.find_each do |issue|
      issue.update!(new_status: status_mapping[issue.status])
    end

    # 古いステータスカラムを削除して新しいカラムをリネーム
    remove_column :issues, :status
    rename_column :issues, :new_status, :status
  end

  def down
    # ロールバックの方法を定義（逆のマッピングを使用）
    status_mapping = {
      'open' => 0,
      'semi-open' => 1,
      'closed' => 2,
      # 他のステータスがあればここにマッピングを追加
    }

    # ステータスを一時的なカラムにコピー
    add_column :issues, :old_status, :string

    # ステータスを文字列に変換
    Issue.find_each do |issue|
      issue.update!(old_status: status_mapping[issue.status])
    end

    # 古いステータスカラムを削除して新しいカラムをリネーム
    remove_column :issues, :status
    rename_column :issues, :old_status, :status
  end
end
