class BranchesController < ApplicationController
  # load_and_authorize_resource
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_branch, only: %i(show edit update destroy)

  def index
    @repository = Repository.find(params[:repository_id])
    @branches = current_repository.branches.order(created_at: :desc).page(params[:page])
  end

  def show
    @repository = @branch.repository
    if @branch.present?
      @branch = @branch
    elsif @new_branch.present?
      @branch = @new_branch
    end
  end

  def new
    @repository = Repository.find(params[:repository_id])
    @branch = @repository.branches.build
  end

  def edit
    @repository = Repository.find(params[:repository_id])
    @repository_id = @repository.id
  end

  def create
    @repository = Repository.find(params[:branch][:repository_id])
    @repository_id = @repository.id
    @branch = Branch.new(branch_params)
    respond_to do |format|
      if @branch.save
        format.html { redirect_to branch_url(@branch), notice: t("branches.Branch was successfully created")}
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  ## 基本的に以下の部分は結構苦労した
  def create_from_existing
    # @user = User.find(params[:user_id])
    @repository = Repository.find(params[:repository_id])
    @repository_id = @repository.id
    @existing_branch = Branch.find(params[:id])
    @new_branch = Branch.new(
      name: "#{@existing_branch.name}のbranch",
      repository_id: @repository.id,
      user_id: params[:user_id],
      status: @existing_branch.status + 1
    )
    if @new_branch.save
      ## 以下でbranchにぶら下がっているdocumentの複製
      @existing_branch.documents.each do |document|
        new_document = document.dup
        new_document.branch = @new_branch
        new_document.save
      end
      # 保存成功
      redirect_to branch_path(@new_branch, branch: @new_branch), notice: t("branches.Branch was successfully created")
    else
      # 保存失敗
      flash[:alert] = "Error: Failed to create a new branch."
      render :show
    end
  end

  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to branch_url(@branch), notice: t("branches.Branch was successfully updated") }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # TODO:owner以外削除できなくすること！  
    @repository_id = params[:repository_id]
    if @branch.status == 0
      respond_to do |format|
        format.html { redirect_to branches_path(repository_id: @repository_id), notice: t("branches.Master branch cannot be deleted destroyed") }
        format.json { head :no_content }
      end
    elsif @branch.status != 0 
      @branch.destroy
      respond_to do |format|
        format.html { redirect_to branches_path(repository_id: @repository_id), notice: t("branches.Branch was successfully destroyed") }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_branch
    @branch = Branch.find(params[:id])
  end

  def branch_params
    params.require(:branch).permit(:name, :repository_id, :user_id)
  end
end