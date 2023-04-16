require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:third_user) { FactoryBot.create(:third_user) }
  let!(:repository) { FactoryBot.create(:repository, user: user) }
  let!(:issue) { FactoryBot.create(:issue, user: user, repository: repository) }

  # ## repository#create
  # describe 'リポジトリ作成' do
  #   context 'リポジトリ作成' do
  #     it 'リポジトリが作成される' do
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
  #       # association :user, factory: :user
  #       click_on '登録する'
  #       expect(Repository.count).to eq(2)
  #       expect(page).to have_content 'リポジトリオーナー'
  #       expect(page).to have_content 'repository_1'
  #     end
  #   end
  # end

  # ## repository#index
  # describe 'リポジトリ一覧' do
  #   context 'リポジトリ一覧' do
  #     it 'リポジトリ一覧が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       expect(Repository.count).to eq(1)
  #       expect(page).to have_content 'Repositories'
  #     end
  #   end
  # end

  # ## repository#show
  # describe 'リポジトリ詳細' do
  #   context 'リポジトリ詳細' do
  #     it 'リポジトリ詳細が表示される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       find('.fa-eye', match: :first).click
  #       expect(page).to have_content 'Repository_1'
  #     end
  #   end
  # end

  ## repository#update
  describe 'リポジトリ更新' do
    context 'リポジトリ更新' do
      it 'リポジトリ詳細が更新される' do
        visit new_user_session_path
        fill_in "user_email", with: "KNG1@example.com"
        fill_in "user_password", with: "11101252"
        click_on "ログイン"
        find('.dropbtn').click  # dropbtnクラスの要素をクリック
        find('.dropdown-content').click_link 'リポジトリ一覧'
        find('.fa-eye', match: :first).click
        sleep 1
        # binding.pry
        within(".Edit-RSpec") do
          click_link("Edit")
        end
        # リポジトリの更新を確認
        # binding.pry
        fill_in "repository_name", with: "おっす"
        ## fill_in "repository_name", with: "Repository_2"とすると、なぜか
        ## 更新ボタンを推していなくても勝手に画面遷移した。その反応が速すぎて、
        ## binding.pryで停止したのち解除してテストすればうまくいくのに、bindingを
        ## はさまないとエラーが出た。まじイミフ。
        ## _の前までが同じだから更新なしとみなされたか、もしくは似過ぎた名前への変更は
        ## RSpecの誤操作につながるのか
        sleep 3
        click_on "更新する"
        expect(page).to have_content 'おっす'
      end
    end
  end

  # ## repository#update
  # describe 'リポジトリ削除' do
  #   context 'リポジトリ削除' do
  #     it 'リポジトリが削除される' do
  #       visit new_user_session_path
  #       fill_in "user_email", with: "KNG1@example.com"
  #       fill_in "user_password", with: "11101252"
  #       click_on "ログイン"
  #       find('.dropbtn').click  # dropbtnクラスの要素をクリック
  #       find('.dropdown-content').click_link 'リポジトリ一覧'
  #       # 確認ダイアログでOKを押す
  #       accept_confirm do
  #         find(".fa-trash").click
  #       end
  #       # リポジトリの削除を確認
  #       expect(page).to have_content 'Repositories'      
  #       expect(Repository.count).to eq(0)
  #       expect(page).not_to have_content 'Repository_1'
  #     end
  #   end
  # end
end
