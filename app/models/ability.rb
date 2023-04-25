# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= current_user
    repository_id = Thread.current[:current_repository_id]
    if user&.admin?
      can :access, :rails_admin
      can :manage, :all
    end

    ## branchについて
    ## TODO:とりあえず一度権限制約外した
    can [:read], Branch
    ## TODO:現状、branchはrepositoryの持ち主しか切ることができない。
    # 今後、「チームの一員ならば切れる」「公開されていて誰にでも切れる」なども選択できるようにすること
    can [:create_from_existing, :update], Branch, repository: { user_id: user.id }
    can :destroy, Branch do |branch|
      branch.repository.user_id == user.id || branch.user_id == user.id
    end

    ## conversationについて
    # conversations_controllerで制御。
  
    ## documentについて（結局controllerで制御。以下、コメントアウト）
    # can :read, Document
    # can :create, Document do |document|
    #   repository = Repository.find_by(id: repository_id)
    #   (document.new_record? && branch.user_id == user.id) || (document.new_record? && repository.user_id == user.id)
    # end
    # can [:update, :destroy], Document, branch: { user_id: user.id }
      ## 以下はブランチ作成者以外にもブランチ作成者が許可を出した場合も可能とするという手順を仕様とし始めたもの
      # 2023.4.10現在は不採用
      # document.branch.user_id == user.id || user.allowed_users.include?(document.user)

    ## favorite_repositoryについて
    # ネストしていないindexビューのみなので、ログインしているか否かでなりすましを弾ける

    ## issueについて（結局controllerで制御。以下、コメントアウト）
    # can :read, Issue
    # can :create, Issue do |issue|
    #   repository = Repository.find_by(id: issue.repository_id)
    #   # repository = Repository.find(params[:repository_id]) ←ability.rbではparamsは使えない
    #   # issue.new_record? && repository&.user_id == user.id
    #   issue.new_record? && issue.user == user
    # end
    # can [:update, :destroy], Issue, repository: { user_id: user.id }
    
    ## repositoryについて
    can [:create, :read], Repository
    can :update, Repository, user_id: user.id
    can :destroy, Repository, user_id: user.id  
  end
end
