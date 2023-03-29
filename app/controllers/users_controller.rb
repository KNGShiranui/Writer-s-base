class UsersController < ApplicationController
  before_action :set_user, only: %i(edit update show destroy)
  # before_action :ensure_correct_user, only: %i(show)
  before_action :current_user
  
  def index
    @users = User.all
    # binding.pry
  end

#   def new
#     redirect_to user_path(current_user) if logged_in?
#     @user = User.new # 上記以外の場合はこっち
#   end

#   def create
#     @user = User.new(user_params)
#     if @user.save
#       session[:user_id] = @user.id  # log_inメソッドでもいいかも？
#       redirect_to user_path(@user.id), notice: "ユーザー登録が完了しました" 
#       # redirect_to user_path(session[:user_id])でもOK
#     else
#       render :new, status: :unprocessable_entity 
#     end
#   end

  def show
    @repositories = current_user.repositories
    @conversations = current_user
    redirect_to(repositories_path, danger:"権限がありません") unless current_user == @user
    # set_userで定義した@user = User.find(params[:id])のこと
    # ログインしているユーザーが他のユーザーのページを表示しようとした場合、
    # current_user != @user となり、redirect_to(tasks_path, danger:"権限がありません")
    # によってタスク一覧ページにリダイレクトされます。
  end

#   def edit
#   end
  
#   def update
#     if @user.update(user_params)
#       redirect_to user_path(@user), notice: "ユーザー情報が更新されました。"
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     @user.destroy
#     redirect_to new_session_path, notice: "ユーザー情報が削除されました"
#   end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # def user_params
  #   params.require(:user).permit(:name, :email, :password, :password_confirmation)
  # end

#   def ensure_correct_user
#     @user = User.find_by(id: params[:id])
#     unless @user == current_user || current_user.administrator?
#       flash[:notice] = "権限がありません"
#       redirect_to tasks_path
#     end
#   end
end
