class RelationshipsController < ApplicationController
  # Deviseを使用しているならif logged_in?の代わりに下記を使用する。
  before_action :authenticate_user!
  respond_to? :js # 存在するアクションのrespondを全てjsで返す場合はこのような記述でも可能。

  def following
    @user = current_user
    @users = @user.following
  end
  
  def followers
    @user = current_user
    @followers = @user.followers
  end
  
  def create
    # 自身で作ったログイン機能であれば、独自実装してあるはずの
    # logged_in?メソッドを使用して、ログイン時のみフォローできるようにする。
    # if logged_in?
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to users_path
    # end  
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to users_path
  end
end