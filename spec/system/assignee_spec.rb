require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  # let!(:task) { FactoryBot.create(:task, user: user) }

  ## assignee#create
  describe 'ユーザー編集' do
    context 'プロフィール編集' do
      it 'プロフィール画面が編集される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        click on 'Edit'
        fill_in "user_email", with: "KNG4@example.com"        
        expect(page).to have_content 'KNG1のプロフィール'
        expect(page).to have_content 'KNG1のRepository'
      end
    end
  end
end