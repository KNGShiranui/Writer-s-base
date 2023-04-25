# frozen_string_literal: true

class Documents::ChangesController < ApplicationController
  require 'diff_match_patch'
  
  def show
    @document = Document.find(params[:document_id])
    @branch = Branch.find(params[:branch_id])
    @repository = Repository.find(params[:repository_id])
    @version = @document.versions.find(params[:id])
    @dmp = DiffMatchPatch.new # これで変更箇所のみ強調表示
    # binding.pry
    # 以下のifの条件に合致していないのでこの経路は通っていない
    # if params[:before] && params[:after]
    #   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    #   html_before = markdown.render(params[:before])
    #   html_after = markdown.render(params[:after])
    #   p html_before
    #   p html_after
    #   @diff = Markdiff::Differ.new.render(html_before, html_after)
    # end
  end
end