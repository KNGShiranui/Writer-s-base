class AddNotNullToMessagesContent < ActiveRecord::Migration[6.1]
  def change
    change_column :messages, :content, :text, null: false
  end
end
