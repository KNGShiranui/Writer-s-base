class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
        #  ,:omniauthable, omniauth_providers: %i[github]

  has_many :repositories, dependent: :destroy
  has_many :commits, dependent: :destroy
  has_many :assignees, dependent: :destroy
  has_many :issues, through: :assignees
  has_many :documents, dependent: :destroy
  # has_many :team_members, dependent: :destroy  # 機能拡張時に使うかも
  # has_many :teams, through: :team_members  # 機能拡張時に使うかも
  # has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  # ↑機能拡張時に使うかも
  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

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
  # has_secure_password
  #上の記述はいらないのでコメントアウト。deviseでencrypt_passwordを使用しているので。
end
