require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }
  let!(:issue) { FactoryBot.create(:issue, user: user, repository: repository) }

  ## assignee#create
  describe 'issueにassignする' do
    context 'issueにassignする' do
      it 'issueにassignする' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        # 最初にマッチするリンクを踏む
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        sleep 1
        find('.fa-eye', match: :first).click
        sleep 1
        find('.fa-hand', match: :first).click
        # source上ではfa-hand-paperだったが検証ツール上ではfa-handだった。
        # fa-handでないとエラーが出た。理由は分からないが、今後は検証ツール
        # をメインで使用するべきかも
        expect(page).to have_content 'ユーザ関連イシュー'
        expect(page).to have_content '脱退'
      end
    end
  end

  ## assignee#destroy
  describe 'issueから外れる' do
    context 'issueから外れる' do
      it 'issueから外れる' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        # 最初にマッチするリンクを踏む
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        find('.fa-hand', match: :first).click
        find('.fa-fire', match: :first).click
        expect(page).not_to have_content 'Repository_1'
        expect(page).not_to have_content 'Descriotion_1'
      end
    end
  end
end