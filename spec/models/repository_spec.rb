require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe 'validations' do
    it 'バリデーション通過' do
      repository = FactoryBot.build(:repository)
      expect(repository).to be_valid
    end

    it '名前なし・バリデーション非通過' do
      repository = FactoryBot.build(:repository, name: nil)
      expect(repository).not_to be_valid
    end

    it '反一意性・バリデーション非通過' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:repository, user: user, name: 'test_repository')
      duplicate_repository = FactoryBot.build(:repository, user: user, name: 'test_repository')
      expect(duplicate_repository).not_to be_valid
    end

    it '別ユーザが同名のリポジトリ・バリデーション通過' do
      FactoryBot.create(:repository, user: FactoryBot.create(:user), name: 'test_repository')
      valid_repository = FactoryBot.build(:repository, user: FactoryBot.create(:second_user), name: 'test_repository')
      expect(valid_repository).to be_valid
    end
  end
end