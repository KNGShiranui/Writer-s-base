require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  # let!(:user) { FactoryBot.create(:user) }
  # let!(:second_user) { FactoryBot.create(:second_user) }
  # let!(:third_user) { FactoryBot.create(:third_user) }
  # let!(:task) { FactoryBot.create(:task, user: user) }
  describe '新規作成機能' do
    context 'ユーザーを新規登録した場合' do
      it '登録したユーザーのマイページが表示される' do
        binding.pry
        visit new_user_registration_path
        fill_in "user_name", with: "KNG4"
        fill_in "user_email", with: "KNG4@example.com"
        fill_in "user_password", with: "11101252"
        fill_in "user_password_confirmation", with: "11101252"
        click_on "アカウント登録"
        expect(page).to have_content "KNG4のページ"
      end
    end
  end
  
#   describe 'ログイン要求' do
#     context 'ログインせずタスク一覧画面へ遷移しようとした場合' do
#       it 'ログイン画面が表示される' do
#         visit new_session_path
#         click_on "ログインする"
#         expect(page).to have_content 'ログイン画面'
#       end
#     end
#   end

#   describe 'ログインが可能であること' do
#     context 'ログインをしようとした場合' do
#       it 'ユーザーの画面が表示される' do
#         visit new_session_path
#         fill_in 'session_email', with: 'KNG@example.com'
#         fill_in 'session_password', with: '11101252'
#         click_button 'ログインする'
#         expect(page).to have_content 'KNGのページ'
#         expect(page).to have_content 'KNGのタスク'
#       end
#     end
#   end

#   describe '自分の詳細画面に飛べること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#     end
#     context 'ログインしているユーザが自分のマイページを閲覧できる' do
#       it 'ユーザーの画面が表示される' do
#         click_link "タスク一覧"
#         click_link "Profile"
#         expect(page).to have_content 'KNGのページ'
#         expect(page).to have_content 'KNGのタスク'
#       end
#     end
#   end

#   describe '一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移すること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#     end
#     context '他人の詳細画面に飛ぶと自分のタスク一覧画面に遷移' do
#       it '自分のタスク一覧画面が表示される' do
#         visit user_path(second_user)
#         expect(page).to have_content '権限がありません'
#         expect(page).to have_content 'タスク一覧'
#       end
#     end
#   end

#   describe 'ログアウトができること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#     end
#     context 'ユーザがログアウトボタンをクリックした場合' do
#       it "ログアウトできる" do
#         click_link "Logout"
#         expect(page).to have_content 'ログアウトしました'
#       end
#     end
#   end


#   describe '管理ユーザは管理画面にアクセスできること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG3@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#     end
#     context '管理ユーザが管理者画面ボタンをクリックした場合' do
#       it "管理者画面に遷移できる" do
#         click_link "管理者画面"
#         expect(page).to have_content '管理者画面'
#         expect(page).to have_content 'ユーザ一覧'
#       end
#     end
#   end

#   describe '一般ユーザは管理画面にアクセスできないこと' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#     end
#     context '一般ユーザが管理者画面ボタンをクリックした場合' do
#       it "タスク一覧画面に遷移する" do
#         click_link "管理者画面"
#         expect(page).to have_content '許可されていません'
#         expect(page).to have_content 'タスク一覧'
#       end
#     end
#   end

#   describe '管理ユーザはユーザの新規登録ができること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG3@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#       click_link "管理者画面"
#       click_link "管理者ユーザ作成"
#     end
#     context '管理ユーザがCreate userをクリックした場合' do
#       it "ユーザを新規作成できる" do
#         fill_in 'user_name', with: 'KNG4'
#         fill_in 'user_email', with: 'KNG4@example.com'
#         fill_in 'user_password', with: '11101252'
#         fill_in 'user_password_confirmation', with: '11101252'
#         click_on "Create user"
#         expect(page).to have_content 'ユーザを作成'
#         expect(page).to have_content 'KNG4'
#       end
#     end
#   end

#   describe '管理ユーザはユーザの詳細画面にアクセスできること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG3@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#       click_link "管理者画面"
#     end
#     context '管理ユーザがDetailボタンをクリックした場合' do
#       it "ユーザーの詳細画面を表示できる" do
#         visit administrator_user_path(second_user)
#         expect(page).to have_content 'KNG2のページ'
#       end
#     end
#   end

#   describe '管理ユーザはユーザの編集画面からユーザを編集できること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG3@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#       click_link "管理者画面"
#     end
#     context '管理ユーザがEditボタンをクリックした場合' do
#       it "ユーザーの編集画面を表示し、さらに更新できる" do
#         click_link "Edit", match: :first
#         # visit edit_administrator_user_path(second_user)
#         fill_in 'user_name', with: 'KNG5'
#         fill_in 'user_email', with: 'KNG5@example.com'
#         fill_in 'user_password', with: '11101252'
#         fill_in 'user_password_confirmation', with: '11101252'
#         click_on "update user"
#         expect(page).to have_content 'ユーザを更新'
#         expect(page).to have_content 'KNG5'
#       end
#     end
#   end

#   describe '管理ユーザはユーザの削除をできること' do
#     before do
#       visit new_session_path
#       fill_in 'session_email', with: 'KNG3@example.com'
#       fill_in 'session_password', with: '11101252'
#       click_button 'ログインする'
#       click_link "管理者画面"
#     end
#     context '管理ユーザがDestroyボタンをクリックした場合' do
#       it "ユーザ情報を削除できる" do
#         click_link "Delete", match: :first
#         page.driver.browser.switch_to.alert.accept
#         expect(page).to have_content 'ユーザを削除'
#       end
#     end
#   end
end