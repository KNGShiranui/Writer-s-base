class DocumentsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_document, only: %i(show edit update destroy)

  def index
    @repository = Repository.find(params[:repository_id])
    @branch = @repository.branches.find(params[:branch_id])
    # @documents = Document.all.includes(:user).order(created_at: :desc).page(params[:page])
    @documents = @branch.documents.order(created_at: :desc).page(params[:page])
  end
  
  def show
    
    @document = Document.find(params[:id])
    @repository = params[:repository_id] 
    @branch = params[:branch_id]
  end
  
  def new
    # binding.pry
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
    @document = @branch.documents.build
  end

  def edit
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
  end

  def create
    @document = Document.new(document_params)
    @repository = Repository.find(params[:document][:repository_id])
    @branch = Branch.find(params[:document][:branch_id])
    respond_to do |format|
      if @document.save
        format.html { redirect_to document_url(@document, repository_id: @repository.id, branch_id: @branch.id), notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # binding.pry
    @repository = Repository.find(params[:document][:repository_id])
    @branch = Branch.find(params[:document][:branch_id])
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to document_url(@document, repository_id: @repository.id, branch_id: @branch.id), notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_path(repository_id: @repository.id, branch_id: @branch.id), notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :content, :user_id, :branch_id)
  end
end
