require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }
  let!(:branch) { FactoryBot.create(:branch, user: user, repository: repository) }

  ## branch#index
  describe 'ブランチ一覧' do
    context 'ブランチ一覧' do
      it 'ブランチ一覧が表示される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        expect(page).to have_content 'Branch_1'
      end
    end
  end

  ## branch#show
  describe 'ブランチ詳細' do
    context 'ブランチ詳細' do
      it 'ブランチ詳細が表示される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        sleep 1
        find('.fa-eye', match: :first).click
        expect(page).to have_content 'Branch_1'
        expect(page).to have_content 'branchを切る'
      end
    end
  end

  ## branch#update
  describe 'ブランチ更新' do
    context 'ブランチ更新' do
      it 'ブランチが更新される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        sleep 1
        find('.fa-pencil', match: :first).click
        fill_in "branch_name", with: "DIC"
        click_on "更新する"
        expect(page).to have_content 'DIC'
        expect(page).to have_content 'branchを切る'
      end
    end
  end

  ## branch#destroy
  describe 'ブランチ削除' do
    context 'ブランチ削除' do
      it 'ブランチが削除される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        sleep 1
        accept_confirm do
          find(".fa-trash").click
        end
        expect(page).to have_content 'Branch was successfully destroyed.'
      end
    end
  end

  ## TODO:branch#create_from_existingその1
  describe 'ブランチの複製' do
    context 'ブランチの複製' do
      it 'ブランチを複製できる' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.fa-eye', match: :first).click
        sleep 1
        find('.fa-eye', match: :first).click
        # binding.pry
        click_on 'branchを切る'
        expect(page).to have_content 'Branch_1'
      end
    end
  end

  # ## TODO:branch#create_from_existingその2
  # ## createはrepositoryの新規作成時のみに同時に実行されるのでテストなし。
  # describe 'ブランチ複製' do
  #   context 'ブランチ複製' do
  #     it 'ブランチが複製される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       click_on 'New Repository'
  #       fill_in "repository_name", with: "repository_1"
  #       fill_in "repository_description", with: "description_1"
  #       # fill_in "repository_status", with: "open"
  #       # fill_in "repository_priority", with: "high"
  #       # binding.pry
  #       fill_in "repository_user_id", with: "#{user.id}"
  #       # binding.pry
  #       # association :user, factory: :user
  #       click_on '登録する'
  #       sleep 1
  #       binding.pry
  #       new_repository = Repository.find_by(name: "repository_1")
  #       expect(new_repository).to be_present
  #       # binding.pry
  #       new_branch = Branch.find_by(repository: new_repository)
  #       expect(new_branch).to be_present
  #       find('.fa-eye', match: :first).click
  #       click_on 'branchを切る'
  #       click_on 'Back'
  #       expect(page).to have_content 'Branch_1'
  #       expect(page).to have_content 'Branch_1のbranch'
  #     end
  #   end
  # end
end