class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  respond_to? :js # 存在するアクションのrespondを全てjsで返す場合はこのような記述でも可能。

  def following
    if current_user.id == params[:user_id]
      @user = current_user
      @users = @user.following.page(params[:page]).per(5)
    else  # current_user != @user
      @user = User.find(params[:user_id])
      @users = @user.following.page(params[:page]).per(5)
    end
  end

  def followers
    if current_user.id == params[:user_id]
      @user = current_user
      @followers = @user.followers.page(params[:page]).per(5)
    else
      @user = User.find(params[:user_id])
      @followers = @user.followers.page(params[:page]).per(5)
    end
  end
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to users_path
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to users_path
  end
end
