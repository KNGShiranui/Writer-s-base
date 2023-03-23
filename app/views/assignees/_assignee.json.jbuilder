json.extract! assignee, :id, :user_id, :issue_id, :created_at, :updated_at
json.url assignee_url(assignee, format: :json)
