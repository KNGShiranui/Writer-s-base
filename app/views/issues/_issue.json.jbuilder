json.extract! issue, :id, :name, :description, :status, :priority, :repository_id, :created_at, :updated_at
json.url issue_url(issue, format: :json)
