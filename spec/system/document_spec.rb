# require 'rails_helper'
# RSpec.describe 'document管理機能', type: :system do
#   let!(:user) { FactoryBot.create(:user) }
#   let!(:second_user) { FactoryBot.create(:second_user) }
#   let!(:third_user) { FactoryBot.create(:third_user) }
#   let!(:repository) { FactoryBot.create(:repository, user: user) }
#   let!(:branch) { FactoryBot.create(:branch, user: user, repository: repository) }
#   let!(:issue) { FactoryBot.create(:issue, user: user, repository: repository) }
#   let!(:document) { FactoryBot.create(:document, user: user, branch: branch) }
#   let!(:second_document) { FactoryBot.create(:second_document, user: user, branch: branch) }

#   ## document#create & commit#create
#   describe 'documentの作成' do
#     context 'documentの作成' do
#       it 'documentを作成できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         click_on 'New Document'
#         fill_in "document_name", with: "KNGのいたずら日記"
#         trix_editor = find(".trix-content")
#         # trix_input = find("document_content")
#         execute_script("arguments[0].editor.insertString('KNGのいたずら日記')", trix_editor.native)
#         # fill_in "document_user_id", with: "KNGのいたずら日記"
#         # fill_in "document_branch_id", with: "KNGのいたずら日記"
#         # fill_in "document_repository_id", with: "KNGのいたずら日記"
#         fill_in "document_commit_attributes_message", with: "いたずらにコミットする"
#         click_on '登録する'
#         expect(page).to have_content 'KNGのいたずら日記'
#         expect(page).to have_content 'いたずらにコミットする'
#       end
#     end
#   end

#   ## document#index
#   describe 'document一覧' do
#     context 'document一覧' do
#       it 'document一覧を表示できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         expect(page).to have_content 'Document_1'
#         expect(page).to have_content 'Document_2'
#       end
#     end
#   end

#   ## document#show
#   describe 'document詳細' do
#     context 'document詳細' do
#       it 'document詳細を表示できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         find('.fa-eye', match: :first).click
#         expect(page).to have_content 'Document_2'
#       end
#     end
#   end

#   ## document#update &commit#update
#   describe 'document更新' do
#     context 'document更新' do
#       it 'documentを更新できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         click_on 'New Document'
#         fill_in "document_name", with: "KNGのいたずら日記"
#         trix_editor = find(".trix-content")
#         # trix_input = find("document_content")
#         execute_script("arguments[0].editor.insertString('KNGのいたずら日記')", trix_editor.native)
#         # fill_in "document_user_id", with: "KNGのいたずら日記"
#         # fill_in "document_branch_id", with: "KNGのいたずら日記"
#         # fill_in "document_repository_id", with: "KNGのいたずら日記"
#         fill_in "document_commit_attributes_message", with: "いたずらにコミットする"
#         click_on '登録する'
#         # binding.pry
#         find('.fa-pen-to-square', match: :first).click
#         fill_in "document_name", with: "変更したぜ！！！！"
#         fill_in "document_commit_attributes_message", with: "いたずらにコミットする。その2"
#         click_on '更新する'
#         # binding.pry
#         expect(page).to have_content '変更したぜ！！！！'
#         expect(page).to have_content 'いたずらにコミットする。その2'
#       end
#     end
#   end

#   ## document#destroy
#   describe 'document削除' do
#     context 'document削除' do
#       it 'documentを削除できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         sleep 1
#         # binding.pry
#         accept_confirm do
#           find(".fa-trash", match: :first).click
#         end
#         expect(page).to have_content 'Document was successfully destroyed.'
#       end
#     end
#   end

#   ## change#index & version#index
#   describe '差分表示' do
#     context '差分表示' do
#       it '差分を表示できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         sleep 1
#         # binding.pry
#         find('.fa-pen-to-square', match: :first).click
#         fill_in "document_name", with: "変更したぜ！！！！"
#         click_on '更新する'
#         # binding.pry
#         expect(page).to have_content('このバージョンを表示する', count: 2)
#         expect(page).to have_content('差分を表示する', count: 2)
#       end
#     end
#   end

#   ## version#show
#   describe 'バージョン詳細' do
#     context 'バージョン詳細' do
#       it 'バージョン詳細を表示できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         sleep 1
#         find('.fa-pen-to-square', match: :first).click
#         fill_in "document_name", with: "変更したぜ！！！！"
#         click_on '更新する'
#         click_on 'このバージョンを表示する', match: :first
#         expect(page).to have_content('変更したぜ！！！！', count: 1)
#         expect(page).to have_content('Document_2', count: 1)
#         expect(page).to have_content('Content_2', count: 1)
#         expect(page).not_to have_content('差分を表示する')
#       end
#     end
#   end

#   ## change#show
#   describe '差分詳細' do
#     context '差分詳細' do
#       it '差分詳細を表示できる' do
#         visit new_user_session_path
#         fill_in "user_email", with: "KNG1@example.com"
#         fill_in "user_password", with: "11101252"
#         click_on "ログイン"
#         find('.fa-eye', match: :first).click
#         sleep 1
#         find('.fa-eye', match: :first).click
#         click_on 'Document一覧'
#         sleep 1
#         find('.fa-pen-to-square', match: :first).click
#         fill_in "document_name", with: "変更したぜ！！！！"
#         click_on '更新する'
#         click_on '差分を表示する', match: :first
#         expect(page).to have_content('変更したぜ！！！！', count: 1)
#         expect(page).to have_content('Document_2', count: 1)
#         expect(page).to have_content('Content_2', count: 1)
#         expect(page).to have_content('差分を表示する', count: 1)
#       end
#     end
#   end
# end