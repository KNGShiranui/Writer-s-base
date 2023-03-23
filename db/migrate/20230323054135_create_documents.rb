class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :name, null: false, default: "", limit: 100
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
