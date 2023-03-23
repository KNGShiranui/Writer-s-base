json.extract! document, :id, :name, :content, :user_id, :branch_id, :created_at, :updated_at
json.url document_url(document, format: :json)
