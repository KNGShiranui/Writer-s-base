require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }

  ## favorite_repository#create
  describe 'リポジトリお気に入り' do
    context 'リポジトリお気に入り' do
      it 'リポジトリをお気に入りに追加できる' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        click_on 'お気に入り'
        expect(page).to have_content 'お気に入り解除'
      end
    end
  end
  ## favorite_repository#destroy
  describe 'リポジトリお気に入り' do
    context 'リポジトリお気に入り解除' do
      it 'リポジトリのお気に入りを解除できる' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        click_on 'お気に入り'
        click_on 'お気に入り解除'
        expect(page).not_to have_content 'お気に入り解除'
      end
    end
  end
  ## favorite_repository#index
  describe 'リポジトリお気に入り一覧' do
    context 'リポジトリお気に入り一覧表示' do
      it 'リポジトリのお気に入り一覧を表示できる' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'お気に入りリポジトリ'
        expect(page).not_to have_content 'お気に入りリポジトリ一覧        '
      end
    end
  end
end