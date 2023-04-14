# # spec/models/issue_spec.rb
# require 'rails_helper'

# RSpec.describe Issue, type: :model do
#   describe 'バリデーション' do
#     it 'バリデーション通過' do
#       issue = FactoryBot.build(:issue)
#       expect(issue).to be_valid
#     end

#     it '名前なし・バリデーション非通過' do
#       issue = FactoryBot.build(:issue, name: nil)
#       expect(issue).not_to be_valid
#     end

#     it '説明なし・バリデーション非通過' do
#       issue = FactoryBot.build(:issue, description: nil)
#       expect(issue).not_to be_valid
#     end

#     it 'ステータスなし・バリデーション非通過' do
#       issue = FactoryBot.build(:issue, status: nil)
#       expect(issue).not_to be_valid
#     end

#     it '優先度なし・バリデーション非通過' do
#       issue = FactoryBot.build(:issue, priority: nil)
#       expect(issue).not_to be_valid
#     end
#   end
# end
