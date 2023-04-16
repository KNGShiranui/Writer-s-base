require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'バリデーションテスト' do
    it 'バリデーション通過' do
      branch = FactoryBot.build(:branch)
      expect(branch).to be_valid
    end

    it '名前なし・バリデーション非通過' do
      branch = FactoryBot.build(:branch, name: nil)
      expect(branch).not_to be_valid
    end
  end
end

