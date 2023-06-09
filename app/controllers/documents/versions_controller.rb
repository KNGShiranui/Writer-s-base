# frozen_string_literal: true

class Documents::VersionsController < ApplicationController
  def show
    @document = Document.find(params[:document_id])
    @branch = Branch.find(params[:branch_id])
    @repository = Repository.find(params[:repository_id])
    @version = @document.versions.find(params[:id])
  end

  def update  
    @document = Document.find(params[:document_id])
    @branch = Branch.find(params[:branch_id])
    @repository = Repository.find(params[:repository_id])
    @version = @document.versions.find(params[:id])
    if @version.next.present?
      @document = @version.next.reify
      @document.save!
    end
    redirect_to document_path(@document, branch_id: @document.branch.id, repository_id: @document.branch.repository.id)
  end
end