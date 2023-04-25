class Repository < ApplicationRecord
  belongs_to :user
  has_many :branches, dependent: :destroy
  has_many :issues, dependent: :destroy
  ## 以下でリポジトリのお気に入りを定義
  has_many :favorite_repositories, dependent: :destroy
  has_many :favorited_by_users, through: :favorite_repositories, source: :user
  has_many :repository_labels, dependent: :destroy
  has_many :labels, through: :repository_labels

  validates :name, presence: true, uniqueness: { scope: :user_id }
  
  enum status: %i[open semi_closed closed], _prefix: true
  enum priority: %i[very_low low medium high very_high immediately], _prefix: true

  # ransack使用のためのattributes設定
  def self.ransackable_attributes(auth_object = nil)
    %w[name description]
  end

  # ransack使用のためのassociations設定
  def self.ransackable_associations(auth_object = nil)
    %w[repository]
  end
end
