class AddDraftContentToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :draft_content, :text
  end
end
