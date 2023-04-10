# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # 以下のコードの意味の解説
    # ログイン中のユーザに管理者権限がある場合はrails_adminへのアクセスと、
    # すべてのモデルのCRUD（Create、Read、Update、Delete）を許可する
    if user&.admin?
      can :access, :rails_admin
      can :manage, :all
    end
    ## リポジトリ
    can [:create, :read], Repository
    can [:update], Repository, user_id: user.id
    can :destroy, Repository, user_id: user.id
  
    ## ブランチ
    can [:create, :read], Branch
    can [:update], Branch, repository: { user_id: user.id }
    can :destroy, Branch do |branch|
      branch.repository.user_id == user.id || branch.user_id == user.id
    end
  
    ## ドキュメント
    can :create, Document
    can [:read, :update], Document, user_id: user.id
    can :destroy, Document do |document|
      document.branch.user_id == user.id || user.allowed_users.include?(document.user)
    end
  end

  ## 以下参考
  # class Ability
  #   include CanCan::Ability

  #   def initialize(user)
  #     can :read, Post, public: true

  #     return unless user.present?  # additional permissions for logged in users (they can read their own posts)
  #     can :read, Post, user: user

  #     return unless user.admin?  # additional permissions for administrators
  #     can :read, Post
  #   end
  # end

end
