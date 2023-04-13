require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }
  let!(:issue) { FactoryBot.create(:issue, user: user, repository: repository) }

  ## relationship#create
  describe 'フォローする' do
    context 'フォローする' do
      it '他のユーザをフォローする' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'ユーザ一覧'
        target_user_name = "KNG2"
        find(".user-item[data-user-name='#{target_user_name}'] .follow-button").click
        # binding.pry
        within(".user-item[data-user-name='#{target_user_name}']") do
          follow_button = find(".follow-button")
          expect(follow_button[:value]).to eq("つながりを解除")
        end
      end
    end
  end

  ## relationship#destroy
  describe 'フォロー解除' do
    context 'フォロー解除' do
      it '他のユーザのフォローを解除' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'ユーザ一覧'
        target_user_name = "KNG2"
        find(".user-item[data-user-name='#{target_user_name}'] .follow-button").click
        find(".user-item[data-user-name='#{target_user_name}'] .follow-button").click
        within(".user-item[data-user-name='#{target_user_name}']") do
          follow_button = find(".follow-button")
          expect(follow_button[:value]).to eq("フォロー")
        end
      end
    end
  end

  ## relationship#following
  describe 'フォローしている人' do
    context 'フォローしている人' do
      it 'フォローしている人の表示' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'ユーザ一覧'
        target_user_name = "KNG2"
        find(".user-item[data-user-name='#{target_user_name}'] .follow-button").click
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'フォロー'
        expect(page).to have_content 'KNG2'
        expect(page).to have_content 'フォロー'
      end
    end
  end

  ## relationship#following
  describe 'フォローしている人' do
    context 'フォローしている人' do
      it 'フォローしている人の表示' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'フォロワー'
        expect(page).to have_content 'フォロワー'
      end
    end
  end
end
