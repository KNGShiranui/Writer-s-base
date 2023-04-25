class AssigneesController < ApplicationController
  before_action :set_issue, only: %i(create destroy)
  before_action :set_assignee, only: %i(new create edit update destroy)

  def index
    @assignees = Assignee.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @assignee = Assignee.new
  end

  def edit
  end

  def create
    if params[:repository_id].present?
      @user = User.find(params[:user_id])
      @issue = Issue.find(params[:issue])
      @repository = Repository.find(@issue.repository.id)
      @assignee = @issue.assignees.create(user: @user)
      redirect_to issues_path(repository_id: @issue.repository.id)
    elsif params[:user_id].present? && !params[:repository_id].present?
      @user = User.find(params[:user_id])
      @issue = Issue.find(params[:issue])
      @repository = Repository.find(@issue.repository.id)
      @assignee = @issue.assignees.create(user: @user)
      redirect_to issues_path(user_id: current_user.id)
    end
  end

  def destroy
    if params[:repository_id].present?
      @user = User.find(params[:user_id])
      @issue = Issue.find(params[:issue])
      @assignee.destroy if @assignee
      redirect_to issues_path(repository_id: @issue.repository.id)
    elsif params[:user_id].present? && !params[:repository_id].present?
      @user = User.find(params[:user_id])
      @issue = Issue.find(params[:issue])
      @assignee.destroy if @assignee
      redirect_to issues_path(user_id: current_user.id)
    end
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue])
  end

  def set_assignee
    @assignee = @issue.assignees.find_by(user_id: params[:user_id])
  end

  def assignee_params
    params.require(:assignee).permit(:user_id, :issue_id)
  end
end