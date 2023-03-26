class Repository < ApplicationRecord
  belongs_to :user
  has_many :branches
  has_many :issues
  # has_many :repository_holder_teams, dependent: :destroy # 機能拡張時に使うかも
  # has_many :teams, through: :repository_holder_teams # 機能拡張時に使うかも

  validates :name, presence: true, uniqueness: { scope: :user_id }
  # validates :access_level, presence: true, inclusion: { in: %w[public private] } # 機能拡張時に使うかも
end
