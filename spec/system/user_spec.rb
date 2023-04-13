require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  # let!(:task) { FactoryBot.create(:task, user: user) }

  # ## session_login（通常）
  # describe 'ログイン要求' do
  #   context 'ログインした場合' do
  #     it 'ユーザー画面が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       expect(page).to have_content '現在のユーザー: KNG1さん'
  #     end
  #   end
  # end
  # describe 'ログイン要求' do
  #   context 'ログインに失敗した場合' do
  #     it 'ログイン画面が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG11111@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       expect(page).to have_content 'Eメールまたはパスワードが違います。'
  #     end
  #   end
  # end

  # ## session_login（ゲスト）
  # describe 'ゲストログイン' do
  #   context 'ログインした場合' do
  #     it 'ゲストログイン画面が表示される' do
  #       visit new_user_session_path
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'ゲストログイン'
  #       expect(page).to have_content 'ゲストユーザーとしてログインしました。'
  #     end
  #   end
  # end

  # ## session_login（ゲスト管理者）
  # describe 'ゲスト管理者ログイン' do
  #   context 'ログインした場合' do
  #     it 'ゲスト管理者ログイン画面が表示される' do
  #       visit new_user_session_path
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'ゲスト管理者ログイン'
  #       expect(page).to have_content 'ゲスト管理者としてログインしました。'
  #     end
  #   end
  # end

  ## user#create
  describe '新規作成機能' do
    context 'ユーザーを新規登録した場合' do
      it '登録したユーザーのマイページが表示される' do
        # binding.pry
        visit new_user_registration_path
        fill_in "user_name", with: "KNG4"
        fill_in "user_email", with: "KNG4@example.com"
        fill_in "user_password", with: "11101252"
        fill_in "user_password_confirmation", with: "11101252"
        click_on "アカウント登録・更新"
        expect(page).to have_content "現在のユーザー: KNG4さん"
      end
    end
  end
  
  # ## user#index
  # describe 'ユーザー表示' do
  #   context '一覧表示' do
  #     it 'ユーザー一覧画面が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'ユーザ一覧'
  #       expect(page).to have_content 'メッセージを送る'
  #       expect(page).to have_content 'KNG2さん'
  #       expect(page).to have_content 'KNG3さん'
  #     end
  #   end
  # end

  # ## user#show
  # describe 'ユーザー表示' do
  #   context 'プロフィール表示' do
  #     it 'プロフィール画面が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'プロフィール'
  #       expect(page).to have_content 'KNG1のプロフィール'
  #       expect(page).to have_content 'KNG1のRepository'
  #     end
  #   end
  # end

  # ## TODO:user#update
  # describe 'ユーザー編集' do
  #   context 'プロフィール編集' do
  #     it 'プロフィール画面が編集される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'プロフィール'
  #       find('.fa-pencil', match: :first).click
  #       fill_in "user_name", with: "KNG4"
  #       fill_in "user_email", with: "KNG4@example.com"
  #       fill_in "user_password", with: "11101252"
  #       fill_in "user_password_confirmation", with: "11101252"
  #       # fill_in "user_current_password", with: "11101252"
  #       click_on "アカウント登録・更新"
  #       expect(page).to have_content 'ユーザー情報が更新されました'
  #       fill_in "user_email", with: "KNG4@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       expect(page).to have_content 'KNG4'
  #     end
  #   end
  # end
end