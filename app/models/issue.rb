class Issue < ApplicationRecord
  belongs_to :repository
  has_many :assignees, dependent: :destroy
  has_many :users, through: :assignees

  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true # これは公開か非公開かを振り分けてる？
  validates :priority, presence: true

  enum status: { open: 0, semi_open: 1, closed: 2 }, _prefix: true
  enum status: { very_low: 0, low: 1, medium: 2, high: 3, very_high: 4, immediately: 5 }, _prefix: true
end
