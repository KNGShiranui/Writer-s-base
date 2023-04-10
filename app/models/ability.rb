# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    ## 以下2行はcancancan関係のための記述（issues_controller、ability.rb、application_controllerに記載あり
    ## ややこしいので気を付けて！
    user ||= User.new
    repository_id = Thread.current[:current_repository_id]
    # 以下のコードの意味の解説
    # ログイン中のユーザに管理者権限がある場合はrails_adminへのアクセスと、
    # すべてのモデルのCRUD（Create、Read、Update、Delete）を許可する
    if user&.admin?
      can :access, :rails_admin
      can :manage, :all
    end
    ## リポジトリ
    can [:create, :read], Repository
    can :update, Repository, user_id: user.id
    can :destroy, Repository, user_id: user.id
  
    ## ブランチ
    can [:read], Branch
    can [:create_from_existing, :update], Branch, repository: { user_id: user.id }
    can :destroy, Branch do |branch|
      branch.repository.user_id == user.id || branch.user_id == user.id
    end
  
    ## ドキュメント
    # binding.pry
    can :read, Document
    can [:create, :update], Document, branch: { user_id: user.id }
    can [:destroy], Document do |document|
      document.branch.user_id == user.id
    end
      ## 以下はブランチ作成者以外にもブランチ作成者が許可を出した場合も可能とするという手順を仕様とし始めたもの
      # 2023.4.10現在は不採用
      # document.branch.user_id == user.id || user.allowed_users.include?(document.user)

    ## イシュー
    can :read, Issue
    can :create, Issue do |issue|
      repository = Repository.find_by(id: repository_id)
      # repository = Repository.find(params[:repository_id]) ←ability.rbではparamsは使えない
      # issue.new_record? && repository&.user_id == user.id
      issue.new_record? && repository.user_id == user.id
    end
    can [:update, :destroy], Issue, repository: { user_id: user.id }
    ## コミット
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
