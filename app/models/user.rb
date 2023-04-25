class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :repositories, dependent: :destroy
  has_many :commits, dependent: :destroy
  has_many :assignees, dependent: :destroy
  has_many :branches, dependent: :destroy
  has_many :issues, through: :assignees
  has_many :documents, dependent: :destroy
  # has_many :team_members, dependent: :destroy  # 機能拡張時に使うかも
  # has_many :teams, through: :team_members  # 機能拡張時に使うかも
  # has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :sent_conversations, foreign_key: :sender_id, class_name: 'Conversation', dependent: :destroy
  has_many :received_conversations, foreign_key: :recipient_id, class_name: 'Conversation', dependent: :destroy

  ## 以下でリポジトリのお気に入りを定義
  has_many :favorite_repositories, dependent: :destroy
  has_many :favorited_repositories, through: :favorite_repositories, source: :repository

  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, on: :create
  validates :password, length: { minimum: 6 }, confirmation: true, allow_blank: true, on: :update

  #指定のユーザをフォローする
  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  #フォローしているかどうかを確認する
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  ## ransack使用のためのattributes設定
  def self.ransackable_attributes(auth_object = nil)
    %w[name content]
  end

  ## ransack使用のためのassociations設定
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  ## ゲストユーザーに関するメソッド
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'Guest User'
    end
  end

  ## ゲスト管理者に関するメソッド
  def self.guest_admin
    find_or_create_by!(email: 'guest_admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'Guest Admin'
      user.admin = true
    end
  end

  ## ポイントを他のユーザに渡すためのメソッド  #points_controllerと関係
  def send_points(receiver, amount)
    return false if self == receiver || self.points < amount || amount <=0
    ActiveRecord::Base.transaction do
      self.points -= amount
      receiver.points += amount
      self.save!
      receiver.save!
    end
    true
    rescue StandardError => e
    false
  end
end
