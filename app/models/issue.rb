class Issue < ApplicationRecord
  belongs_to :repository
  belongs_to :user
  has_many :assignees, dependent: :destroy
  has_many :users, through: :assignees

  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true # これは公開か非公開かを振り分けてる
  validates :priority, presence: true

  enum status: %i[open semi_closed closed], _prefix: true
  enum priority: %i[very_low low medium high very_high immediately], _prefix: true

  scope :in_progress, -> {where(progress: true)}
  scope :closed, -> {where(progress: false)}
end
