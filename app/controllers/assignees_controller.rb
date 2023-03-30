class AssigneesController < ApplicationController
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
    user = User.find(params[:user_id])
    @issue.assignees.create(user: user)
    redirect_to @issue
  end

  def destroy
    user = User.find(params[:user_id])
    assignee = @issue.assignees.find_by(user: user)
    assignee.destroy if assignee
    redirect_to @issue
  end

  private
  def set_assignee
    @assignee = Assignee.find(params[:id])
  end

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def assignee_params
    params.require(:assignee).permit(:user_id, :issue_id)
  end
end
