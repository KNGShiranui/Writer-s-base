class Repository < ApplicationRecord
  belongs_to :user
  has_many :branches, dependent: :destroy
  # dependent: :destroyを書かないと以下のエラーが出る。
  # branches テーブルのレコードが存在している場合、repositoriesテーブルのレコード
  # を削除することができないことを示している
  # ActiveRecord::InvalidForeignKey at /repositories/1
  # PG::ForeignKeyViolation: ERROR:  update or delete on table "repositories" 
  # violates foreign key constraint "fk_rails_ce3c7008c0" on table "branches"
  # DETAIL:  Key (id)=(1) is still referenced from table "branches".
  has_many :issues, dependent: :destroy
  # has_many :repository_holder_teams, dependent: :destroy # 機能拡張時に使うかも
  # has_many :teams, through: :repository_holder_teams # 機能拡張時に使うかも

  ## 以下でリポジトリのお気に入りを定義
  has_many :favorite_repositories
  has_many :favorited_by_users, through: :favorite_repositories, source: :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  # validates :access_level, presence: true, inclusion: { in: %w[public private] } # 機能拡張時に使うかも
  enum status: %i[open semi_closed closed], _prefix: true
  enum priority: %i[very_low low medium high very_high immediately], _prefix: true
end
