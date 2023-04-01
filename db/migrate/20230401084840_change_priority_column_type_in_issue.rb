class ChangePriorityColumnTypeInIssue < ActiveRecord::Migration[6.1]
  def up
    # 文字列の優先度を整数にマッピング
    priority_mapping = {
      'very_low' => 0,
      'low' => 1,
      'medium' => 2,
      'high' => 3,
      'very_high' => 4,
      'immediately' => 5,
      # 他の優先度があればここにマッピングを追加
    }

    # 優先度を一時的なカラムにコピー
    add_column :issues, :new_priority, :integer

    # 優先度を整数に変換
    Issue.find_each do |issue|
      issue.update!(new_priority: priority_mapping[issue.priority])
    end

    # 古い優先度カラムを削除して新しいカラムをリネーム
    remove_column :issues, :priority
    rename_column :issues, :new_priority, :priority
  end

  def down
    # ロールバックの方法を定義（逆のマッピングを使用）
    priority_mapping = {
      0 => 'very_low',
      1 => 'low',
      2 => 'medium',
      3 => 'high',
      4 => 'very_high',
      5 => 'immediately',
      # 他の優先度があればここにマッピングを追加
    }

    # 優先度を一時的なカラムにコピー
    add_column :issues, :old_priority, :string

    # 優先度を文字列に変換
    Issue.find_each do |issue|
      issue.update!(old_priority: priority_mapping[issue.priority])
    end

    # 古い優先度カラムを削除して新しいカラムをリネーム
    remove_column :issues, :priority
    rename_column :issues, :old_priority, :priority
  end
end
