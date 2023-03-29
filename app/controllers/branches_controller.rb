class BranchesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_branch, only: %i(show edit update destroy)

  def index
    @repository = Repository.find(params[:repository_id])  #親リポジトリのデータ取得
    # これでbranchのindexビューからnew branch作成可能になる
    @branches = current_repository.branches.order(created_at: :desc).page(params[:page])
  end

  def show
    @repository = @branch.repository
  end

  def new
    @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    @branch = @repository.branches.build
  end

  def edit
    @repository = Repository.find(params[:repository_id])
    @repository_id = @repository.id
  end

  def create
    @repository = Repository.find(params[:branch][:repository_id])  # 明示的に書く必要あり
    @repository_id = @repository.id # 明示的に書く必要あり
    @branch = Branch.new(branch_params)
    respond_to do |format|
      if @branch.save
        format.html { redirect_to branch_url(@branch), notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to branch_url(@branch), notice: "Branch was successfully updated." }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to branches_url, notice: "Branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_branch
    @branch = Branch.find(params[:id])
  end

  def branch_params
    params.require(:branch).permit(:name, :repository_id)
  end
end
