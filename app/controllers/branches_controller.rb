class BranchesController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_branch, only: %i(show edit update destroy)

  # GET /branches or /branches.json
  def index
    @branches = Branch.all.order(created_at: :desc).page(params[:page])
  end

  # GET /branches/1 or /branches/1.json
  def show
  end

  # GET /branches/new
  def new
    @repository = Repository.find(params[:repository_id]) # 明示的に書く必要あり
    @branch = @repository.branches.build
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches or /branches.json
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

  # PATCH/PUT /branches/1 or /branches/1.json
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

  # DELETE /branches/1 or /branches/1.json
  def destroy
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to branches_url, notice: "Branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def branch_params
      params.require(:branch).permit(:name, :repository_id)
    end
end
