require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }
  let!(:issue) { FactoryBot.create(:issue, user: user, repository: repository) }
  let!(:issue) { FactoryBot.create(:issue, user: second_user, repository: repository) }

  # ## issue#create
  # describe 'issueの作成' do
  #   context 'issueの作成' do
  #     it 'issueを作成する' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       find('.fa-eye', match: :first).click
  #       click_on "イシュー作成"
  #       fill_in "issue_name", with: "issue_1"
  #       fill_in "issue_description", with: "description_1"
  #       select 'open', from: 'issue_status'
  #       select 'high', from: 'issue_priority'
  #       click_on "登録する"
  #       expect(page).to have_content 'issue_1'
  #       expect(page).to have_content 'description_1'
  #       expect(page).to have_content 'open'
  #       expect(page).to have_content 'high'
  #     end
  #   end
  # end

  # ## issue#show（indexはrepository#showで表示されるためテスト不要）
  # describe 'issueの詳細' do
  #   context 'issueの詳細' do
  #     it 'issueの詳細を表示する' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       find('.fa-eye', match: :first).click
  #       find('.fa-eye', match: :first).click
  #       expect(page).to have_content 'Issue_1'
  #       expect(page).to have_content 'Description_1'
  #       expect(page).to have_content 'open'
  #       expect(page).to have_content 'high'
  #     end
  #   end
  # end

  # ## issue#update
  # describe 'issueの更新' do
  #   context 'issueの更新' do
  #     it 'issueを更新する' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       find('.fa-eye', match: :first).click
  #       click_on "イシュー作成"
  #       fill_in "issue_name", with: "issue_1"
  #       fill_in "issue_description", with: "description_1"
  #       select 'open', from: 'issue_status'
  #       select 'high', from: 'issue_priority'
  #       click_on "登録する"
  #       click_on "Edit"
  #       fill_in "issue_name", with: "KNGのいたずら大作戦"
  #       click_on "更新する"
  #       expect(page).to have_content 'KNGのいたずら大作戦'
  #       expect(page).to have_content 'description_1'
  #       expect(page).to have_content 'open'
  #       expect(page).to have_content 'high'
  #     end
  #   end
  # end

  ## issue#destroy
  describe 'issueの削除' do
    context 'issueの削除' do
      it 'issueを削除する' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        click_on "イシュー作成"
        fill_in "issue_name", with: "issue_1"
        fill_in "issue_description", with: "description_1"
        select 'open', from: 'issue_status'
        select 'high', from: 'issue_priority'
        click_on "登録する"
      end
    end
  end
end