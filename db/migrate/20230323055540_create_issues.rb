class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.string :name, null: false, default: "", limit: 100
      t.string :description, limit: 100
      t.string :status
      t.string :priority
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
