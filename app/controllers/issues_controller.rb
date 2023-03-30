class IssuesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_issue, only: %i(show edit update destroy)

  def index
    if params[:repository_id].present?
      @repository = Repository.find(params[:repository_id])  #親リポジトリのデータ取得
      # @issue = Issue.find(params[:repository_id])
      @issues = current_repository.issues.order(created_at: :desc).page(params[:page]) # issue全件
      # binding.pry
      # @issues = Issue.all.includes(:user).order(created_at: :desc).page(params[:page])
      # おいおいはincludesを使う方がいいと思う。とりあえず今は実装できていないのでコメントアウト。
    elsif params[:user_id].present?
      @issues = current_user.issues.order(created_at: :desc).page(params[:page])
    end
  end

  def show
    # @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    @repository = @issue.repository # これでissueとそれに結び付いたrepositoryを呼び出す
    # それにより
    # binding.pry
  end

  def new
    @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    @issue = @repository.issues.build
  end

  def edit
    @repository = Repository.find(params[:repository_id])
    @repository_id = @repository.id
    # binding.pry
  end

  def create
    # user_id = current_user.id
    @repository = Repository.find(params[:issue][:repository_id])  # 明示的に書く必要あり
    @repository_id = @repository.id # 明示的に書く必要あり
    @issue = Issue.new(issue_params.merge(user_id: current_user.id))
    # .merge(user_id: current_user.id)が重要だった。他の書き方ない？
    respond_to do |format|
      if @issue.save
        format.html { redirect_to issue_url(@issue), notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @repository = Repository.find(params[:issue][:repository_id])  # 明示的に書く必要あり
    @repository_id = @repository.id # 明示的に書く必要あり
    respond_to do |format|
      if @issue.update(issue_params) 
      # .merge(user_id: current_user.id)は不要？idは明示的には編集しないので不要かも
        format.html { redirect_to issue_path(@issue), notice: "Issue was successfully updated." }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository_id = params[:repository_id] # 明示的に書く必要あり？
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_path(repository_id: @repository_id), notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:name, :description, :status, :priority, :user_id, :repository_id)
  end
end
