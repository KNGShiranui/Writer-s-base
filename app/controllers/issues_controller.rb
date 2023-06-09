class IssuesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_issue, only: %i(show edit update destroy)
  # load_and_authorize_resource

  def index
    if params[:repository_id].present?
      @repository = Repository.find(params[:repository_id])
      # FIXME:この行は以下二行に差し替え@issues = current_repository.issues.order(created_at: :desc).page(params[:page]) # issue全件
      @in_progress_issues = current_repository.issues.in_progress.order(created_at: :desc).page(params[:page])
      @closed_issues = current_repository.issues.closed.order(created_at: :desc).page(params[:page])
      # FIXME:おいおいはincludesを使う方がいい。
    elsif params[:user_id].present?
      # @issues = current_user.issues.order(created_at: :desc).page(params[:page])
      @in_progress_issues = current_user.issues.in_progress.order(created_at: :desc).page(params[:page])
      @closed_issues = current_user.issues.closed.order(created_at: :desc).page(params[:page])
    end
  end

  def show
    if @issue.status_closed? && @issue.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to issues_path(repository_id: @repository_id), notice: t("issues.not_authorized") }
      end
    else
      # TODO: elsif @issue.status_semi_closed? && ....
      # TODO:semi_closed実装後、リポジトリに参加しているユーザ内でのみ共有可能にする。
      @repository = @issue.repository
    end
  end

  def new
    # binding.pry
    @repository = Repository.find(params[:repository_id])
    @issue = @repository.issues.build
    params[:user_id] = current_user.id
    if current_user == @repository.user
      @issue = Issue.new(user_id: current_user.id, repository_id: params[:repository_id])
    else
      # リポジトリの作成者ではない場合、適切なエラーメッセージを表示してリダイレクト
      flash[:alert] = t("issues.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def edit
    if @issue.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to issues_path(repository_id: @repository_id), notice: t("issues.not_authorized") }
      end
    else
      @repository = Repository.find(params[:repository_id])
      @repository_id = @repository.id
    end
  end

  def create
    @repository = Repository.find(params[:issue][:repository_id])
    @repository_id = @repository.id
    # リポジトリの作成者のみが新しいissueを作成できるように制御
    if current_user.id == @repository.user_id
      @issue = Issue.new(issue_params.merge(user_id: current_user.id))
      respond_to do |format|
        if @issue.save
          format.html { redirect_to issue_url(@issue), notice: t("issues.Issue was successfully created") }
          format.json { render :show, status: :created, location: @issue }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @issue.errors, status: :unprocessable_entity }
        end
      end
    else
      # リポジトリの作成者ではない場合。
      flash[:alert] = t("issues.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def update
    @repository = Repository.find(params[:issue][:repository_id])
    @repository_id = @repository.id
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to issue_path(@issue), notice: t("issues.Issue was successfully updated") }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_status
      @issue = Issue.find(params[:id])
      @issue.progress = !@issue.progress
      @issue.save
      redirect_to issues_path(repository_id: @issue.repository.id)
  end


  def destroy
    if @issue.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to issues_path(repository_id: @repository_id), notice: t("issues.not_authorized") }
      end
    else
      @repository_id = params[:repository_id]
      @repository = @issue.repository
      @issue.destroy
      respond_to do |format|
        format.html { redirect_to repository_path(@repository, repository_id: @repository.id), notice: t("issues.Issue was successfully destroyed") }
        format.json { head :no_content }
      end
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
