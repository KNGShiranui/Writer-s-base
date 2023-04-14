class AddDraftToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :draft, :boolean, default: false
  end
end
