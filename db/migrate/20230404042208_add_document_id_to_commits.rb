class AddDocumentIdToCommits < ActiveRecord::Migration[6.1]
  def change
    add_reference :commits, :document, foreign_key: true
  end
end
