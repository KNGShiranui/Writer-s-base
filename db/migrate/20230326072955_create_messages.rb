class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :conversation, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :read, default: false # default: falseを追加する

      t.timestamps
    end
  end
end
