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
  # has_many :team_members, dependent: :destroy  # 機能拡張時に使うかも
  # has_many :teams, through: :team_members  # 機能拡張時に使うかも
  # has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  # ↑機能拡張時に使うかも
  
  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }
  # has_secure_password
  #上の記述はいらないのでコメントアウト。deviseでencrypt_passwordを使用しているので。
end
