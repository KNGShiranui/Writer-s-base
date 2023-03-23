class CreateBranches < ActiveRecord::Migration[6.1]
  def change
    create_table :branches do |t|
      t.string :name, null: false, default: "", limit: 100
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
