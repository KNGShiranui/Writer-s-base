class CreateRepositoryLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_labels do |t|
      t.references :repository, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
    add_index :repository_labels, [:repository_id, :label_id], unique: true
  end
end
