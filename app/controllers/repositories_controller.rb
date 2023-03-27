class RepositoriesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_repository, only: %i(show edit update destroy)

  def index
    @repositories = Repository.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
    @branches = Branch.all.order(created_at: :desc).page(params[:page])
    @issues = Issue.all.order(created_at: :desc).page(params[:page])
    # binding.pry
  end

  def new
    @repository = Repository.new
  end

  def edit
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.user = current_user
    respond_to do |format|
      if @repository.save
        format.html { redirect_to repository_url(@repository), notice: "Repository was successfully created." }
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
        format.html { redirect_to repository_url(@repository), notice: "Repository was successfully updated." }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to repositories_url, notice: "Repository was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_repository
    @repository = Repository.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:name, :description, :user_id)
  end
end
