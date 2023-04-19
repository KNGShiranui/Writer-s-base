class RepositoriesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_repository, only: %i(show edit update destroy)

  def index
    # @repositories = Repository.all.includes(:user).order(created_at: :desc).page(params[:page])
    #このよくある１文を下記2行に変換
    @q = Repository.ransack(params[:q])
    @filtered_repositories = @q.result(distinct: true)
    @repositories = Kaminari.paginate_array(@filtered_repositories).page(params[:page]).per(5)
    @count = @repositories.total_count
  end

  def show
    if @repository.status_closed? && @repository.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to repositories_path(repository_id: @repository_id), notice: t("repositories.not_authorized") }
      end
    else
      @branches = current_repository.branches.order(created_at: :desc).page(params[:branches_page])
      # @issues = Issue.all.order(created_at: :desc).page(params[:page])
      @issues = current_repository.issues.all.order(created_at: :desc).page(params[:issues_page])
      # binding.pry
    end
  end

  def new
    @repository = Repository.new
  end

  def edit
    if @repository.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to repositories_path(repository_id: @repository_id), notice: t("repositories.not_authorized") }
      end
    else
    end
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.user = current_user
    respond_to do |format|
      if @repository.save
        @branch = @repository.branches.create(name: 'main', status: 0)
        format.html { redirect_to repository_url(@repository), notice: t("repositories.Repository was successfully created") }
        format.json { render :show, status: :created, location: @repository }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to repository_url(@repository), notice: t("repositories.Repository was successfully updated") }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @repository.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to repositories_path(repository_id: @repository_id), notice: t("repositories.not_authorized") }
      end
    else
      @repository.destroy

      respond_to do |format|
        format.html { redirect_to repositories_url, notice: t("repositories.Repository was successfully destroyed") }
        format.json { head :no_content }
      end
    end
  end

  private
  # def current_repository
  #   @current_repository ||= Repository.find_by(id: @repository[:id])
  # end

  def set_repository
    @repository = Repository.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:name, :description, :status, :priority, :user_id)
  end
end
