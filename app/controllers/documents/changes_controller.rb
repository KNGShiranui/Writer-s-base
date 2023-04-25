# frozen_string_literal: true

class Documents::ChangesController < ApplicationController
  require 'diff_match_patch'
  
  def show
    @document = Document.find(params[:document_id])
    @branch = Branch.find(params[:branch_id])
    @repository = Repository.find(params[:repository_id])
    @version = @document.versions.find(params[:id])
    @dmp = DiffMatchPatch.new
  end
end