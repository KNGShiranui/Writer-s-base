class CreateFavoriteRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
