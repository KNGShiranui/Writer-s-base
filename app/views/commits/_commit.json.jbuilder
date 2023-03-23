json.extract! commit, :id, :message, :user_id, :branch_id, :created_at, :updated_at
json.url commit_url(commit, format: :json)
