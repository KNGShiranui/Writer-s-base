class FavoriteRepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_repositories = current_user.favorited_repositories.page(params[:page])
  end

  def create
    favorite_repository = current_user.favorite_repositories.new(repository_id: params[:repository_id])
    favorite_repository.save
    redirect_to repositories_path
  end

  def destroy
    favorite_repository = current_user.favorite_repositories.find_by(repository_id: params[:repository_id])
    favorite_repository.destroy
    redirect_to repositories_path
  end
end