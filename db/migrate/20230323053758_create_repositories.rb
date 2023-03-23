class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :name, null: false, default: "", limit: 100
      t.text :description, limit: 1000
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
