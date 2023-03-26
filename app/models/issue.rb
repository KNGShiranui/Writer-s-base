class Issue < ApplicationRecord
  belongs_to :repository
  has_many :assignees, dependent: :destroy
  has_many :users, through: :assignees

  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[open closed] }  # これは公開か非公開かを振り分けてる？
  validates :priority, presence: true, inclusion: { in: %w[low medium high] }
end
