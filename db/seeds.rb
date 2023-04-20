# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

# ## Users
# 5.times do |n|
#   User.create!(
#     name: "User #{n + 1}",
#     email: "user#{n + 1}@example.com",
#     encrypted_password: "password",
#     content: "User #{n + 1} content",
#     points: (n + 1) * 100,
#     last_login_bonus_date: n.days.ago
#   )
# end

# ## Repositories
# 5.times do |n|
#   Repository.create!(
#     name: "Repository #{n + 1}",
#     description: "Repository #{n + 1} description",
#     user_id: n + 1,
#     status: n % 3,
#     priority: n % 2
#   )
# end

# ## Issues
# 5.times do |n|
#   Issue.create!(
#     name: "Issue #{n + 1}",
#     description: "Issue #{n + 1} description",
#     repository_id: n + 1,
#     user_id: n + 1,
#     status: n % 2,
#     priority: n % 3
#   )
# end

# ## Assignees
# 5.times do |n|
#   Assignee.create!(
#     user_id: n + 1,
#     issue_id: n + 1
#   )
# end

# ## Branches
# 5.times do |n|
#   Branch.create!(
#     name: "Branch #{n + 1}",
#     repository_id: n + 1,
#     status: n % 2,
#     user_id: n + 1
#   )
# end

# ## Documents
# 5.times do |n|
#   Document.create!(
#     name: "Document #{n + 1}",
#     content: "Document #{n + 1} content",
#     user_id: n + 1,
#     branch_id: n + 1,
#     draft_content: "Document #{n + 1} draft content",
#     draft: n % 2 == 0
#   )
# end

# ## Commits
# 5.times do |n|
#   Commit.create!(
#     message: "Commit #{n + 1}",
#     user_id: n + 1,
#     branch_id: n + 1,
#     document_id: n + 1
#   )
# end

# ## Conversations
# 5.times do |n|
#   Conversation.create!(
#     sender_id: n + 1,
#     recipient_id: ((n + 1) % 5) + 1
#   )
# end

# ## Messages
# 5.times do |n|
#   Message.create!(
#     content: "Message #{n + 1}",
#     conversation_id: n + 1,
#     user_id: n + 1,
#     read: n % 2 == 0
#   )
# end

# ## Relationships
# 5.times do |n|
#   Relationship.create!(
#     follower_id: n + 1,
#     followed_id: ((n + 1) % 5) + 1
#   )
# end

# ## FavoriteRepositories
# 5.times do |n|
#   FavoriteRepository.create!(
#     user_id: n + 1,
#     repository_id: n + 1
#   )
# end

## Labels
labels = [
  "小説",
  "エッセイ",
  "脚本",
  "ブログ",
  "日記",
  "詩",
  "短編小説",
  "ファンタジー",
  "ミステリー",
  "ホラー",
  "SF",
  "ロマンス",
  "アドベンチャー",
  "ノンフィクション",
  "インタビュー",
  "伝記",
  "旅行記",
  "経済",
  "歴史",
  "哲学",
  "環境",
  "テクノロジー",
  "科学",
  "数学"
]

labels.each do |label|
  Label.create!(name: label)
end
