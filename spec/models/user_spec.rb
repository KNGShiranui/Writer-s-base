# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'has a valid factory' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it '名前なし・バリデーション非通過' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'メールアドレスなし・バリデーション非通過' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'メールアドレス帳復・バリデーション非通過' do
      FactoryBot.create(:user, email: 'test@example.com')
      user = FactoryBot.build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it '有効でない入力（正規表現での禁制）・バリデーション非通過' do
      user = FactoryBot.build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it '長すぎる名前・バリデーション非通過' do
      user = FactoryBot.build(:user, name: 'a' * 31)
      expect(user).not_to be_valid
    end

    it '長すぎるメールアドレス・バリデーション非通過' do
      user = FactoryBot.build(:user, email: 'a' * 244 + '@example.com')
      expect(user).not_to be_valid
    end

    it 'パスワードなし・バリデーション非通過' do
      user = FactoryBot.build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
    end

    it '短すぎるパスワード・バリデーション非通過' do
      user = FactoryBot.build(:user, password: 'abcde', password_confirmation: 'abcde')
      expect(user).not_to be_valid
    end

    it '更新時のパスワード空欄・バリデーション非通過' do
      user = FactoryBot.create(:user)
      user.password = ''
      user.password_confirmation = ''
      expect(user).not_to be_valid
    end

    it '更新時の短すぎるパスワード・バリデーション非通過' do
      user = FactoryBot.create(:user)
      user.password = 'abcde'
      user.password_confirmation = 'abcde'
      expect(user).not_to be_valid
    end

    it 'パスワードとパスワード確認の不一致・バリデーション非通過' do
      user = FactoryBot.build(:user, password: 'password123', password_confirmation: 'wrong_password')
      expect(user).not_to be_valid
    end
  end
end
