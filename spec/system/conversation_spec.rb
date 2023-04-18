require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:conversation) { FactoryBot.create(:conversation, sender: user, recipient: second_user) }
  let!(:second_conversation) { FactoryBot.create(:second_conversation, sender: second_user, recipient: third_user) }


  ## conversation#create and message#index
  describe 'チャットルーム作成' do
    context 'チャットルーム作成' do
      it 'チャットルーム作成' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG3@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'ユーザ一覧'
        target_user_name = "KNG1"
        within "tbody" do
        click_link "メッセージ", match: :first
        end
        expect(page).to have_content 'KNG1さんとのメッセージ'
        # target_user_nameは、送りたい相手のユーザー名を指定します。
        # findメソッドは、指定されたCSSセレクタに一致する要素を探します。
        # .user-item[data-user-name='#{target_user_name}']は、data属性data-user-nameがtarget_user_nameと一致する要素を探すセレクタです。これにより、ユーザー名が一致する.user-item要素を見つけます。
        # .send-messageは、見つかった.user-itemの子要素でクラス 名がsend-messageの要素を指定します。
        # clickメソッドは、見つかった要素をクリックするために使用されます。
      end
    end
  end
  
  ## conversation#index
  describe 'チャットルーム一覧表示' do
    context 'チャットルーム一覧表示' do
      it 'チャットルーム一覧表示' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'チャット'
        expect(page).to have_content 'メッセージ一覧'
        expect(page).to have_content 'KNG2'
      end
    end
  end

  ## message#create
  describe 'メッセージ送信機能' do
    context 'メッセージ送信機能' do
      it 'メッセージ送信機能' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'チャット'
        click_on "KNG2"
        fill_in "message[content]", with: "共同開発依頼" # ちょっと苦労した
        click_on "メッセージを送る"
        expect(page).to have_content '共同開発依頼'
        expect(page).to have_content 'KNG2さんとのメッセージ'
      end
    end
  end
end




