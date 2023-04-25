class CommitsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_commit, only: %i(show edit update destroy)

  def index
    @commits = Commit.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @commit = Commit.new
  end

  def edit
  end

  def create
    @commit = Commit.new(commit_params)
    respond_to do |format|
      if @commit.save
        format.html { redirect_to commit_url(@commit) }
        format.json { render :show, status: :created, location: @commit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @commit.update(commit_params)
        format.html { redirect_to commit_url(@commit) }
        format.json { render :show, status: :ok, location: @commit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commit.destroy
    respond_to do |format|
      format.html { redirect_to commits_url }
      format.json { head :no_content }
    end
  end

  private

  def set_commit
    @commit = Commit.find(params[:id])
  end

  def commit_params
    params.require(:commit).permit(:message, :user_id, :branch_id)
  end
end
