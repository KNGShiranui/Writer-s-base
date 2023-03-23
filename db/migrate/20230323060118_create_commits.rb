class CreateCommits < ActiveRecord::Migration[6.1]
  def change
    create_table :commits do |t|
      t.string :message, null: false, default: "", limit: 100
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
