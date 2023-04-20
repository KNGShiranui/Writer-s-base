class IssuesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_issue, only: %i(show edit update destroy)
  # load_and_authorize_resource

  def index
    if params[:repository_id].present?
      @repository = Repository.find(params[:repository_id])  #親リポジトリのデータ取得
      # @issue = Issue.find(params[:repository_id])
      
      # FIXME:この行は以下二行に差し替え@issues = current_repository.issues.order(created_at: :desc).page(params[:page]) # issue全件
      @in_progress_issues = current_repository.issues.in_progress.order(created_at: :desc).page(params[:page])
      @closed_issues = current_repository.issues.closed.order(created_at: :desc).page(params[:page])
      # binding.pry
      # @issues = Issue.all.includes(:user).order(created_at: :desc).page(params[:page])
      # おいおいはincludesを使う方がいいと思う。とりあえず今は実装できていないのでコメントアウト。
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
      # semi_closed実装後、リポジトリに参加しているユーザ内でのみ共有可能にする。
      @repository = @issue.repository # これでissueとそれに結び付いたrepositoryを呼び出す
    end
    # @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    # binding.pry
  end

  def new
    # binding.pry
    @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    @issue = @repository.issues.build
    params[:user_id] = current_user.id
    if current_user == @repository.user
      @issue = Issue.new(user_id: current_user.id, repository_id: params[:repository_id])
    else
      # リポジトリの作成者ではない場合、適切なエラーメッセージを表示してリダイレクト
      flash[:alert] = t("issues.not_authorized")
      redirect_to repository_url(@repository)
    end
    # binding.pry
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
    # binding.pry
  end

  def create
    @repository = Repository.find(params[:issue][:repository_id])  # 明示的に書く必要あり
    @repository_id = @repository.id # 明示的に書く必要あり

    # リポジトリの作成者のみが新しいissueを作成できるように制御
    if current_user.id == @repository.user_id
      @issue = Issue.new(issue_params.merge(user_id: current_user.id))
      # .merge(user_id: current_user.id)が重要だった。他の書き方ない？
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
      # リポジトリの作成者ではない場合、適切なエラーメッセージを表示してリダイレクト
      flash[:alert] = t("issues.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def update
    @repository = Repository.find(params[:issue][:repository_id])  # 明示的に書く必要あり
    @repository_id = @repository.id # 明示的に書く必要あり
    respond_to do |format|
      if @issue.update(issue_params) 
      # .merge(user_id: current_user.id)は不要？idは明示的には編集しないので不要かも
        format.html { redirect_to issue_path(@issue), notice: t("issues.Issue was successfully updated") }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_status
    # if params[:repository_id].present?
      @issue = Issue.find(params[:id])
      @issue.progress = !@issue.progress
      @issue.save
      redirect_to issues_path(repository_id: @issue.repository.id)
    # elsif params[:user_id].present?
    #   @issue = Issue.find(params[:id])
    #   @issue.progress = !@issue.progress
    #   @issue.save
    #   redirect_to issues_path(user_id: current_user.id)
    # end
  end


  def destroy
    if @issue.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to issues_path(repository_id: @repository_id), notice: t("issues.not_authorized") }
      end
    else
      @repository_id = params[:repository_id] # 明示的に書く必要あり？
      @repository = @issue.repository  # repository#showからissueを削除した後、元のrepository#showに戻るために必要な記述だった。苦労した！
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
