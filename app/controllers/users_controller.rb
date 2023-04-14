class UsersController < ApplicationController
  before_action :set_user, only: %i(edit update show destroy)
  # before_action :ensure_correct_user, only: %i(show)  
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :current_user
  
  def index
    @q = User.ransack(params[:q])
    @filtered_users = @q.result(distinct: true).where.not(id: current_user.id)
    @users = Kaminari.paginate_array(@filtered_users).page(params[:page]).per(5) # per(5) の部分は、表示したいユーザー数に応じて調整
    # @users = @q.result(distinct: true).page(params[:page]).order("created_at desc")
    # binding.pry
    @count = @users.total_count
  end

  def new
    redirect_to user_path(current_user) if user_signed_in?
    @user = User.new # 上記以外の場合はこっち
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      current_user = @user
      # log_inメソッドでもいいかも？
      redirect_to new_user_session_path, notice: "ユーザー登録が完了しました" 
      # redirect_to user_path(current_user), notice: "ユーザー登録が完了しました" 
      # redirect_to user_path(session[:user_id])でもOK
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def show
    if current_user == @user
      # リポジトリの表示とページネーション
      @repositories = current_user.repositories.page(params[:repository_page]).per(5).order("created_at desc")
      # 会話のページネーション
      @conversations = Conversation.where("(sender_id = ?) OR (recipient_id = ?)", current_user.id, current_user.id).page(params[:conversation_page]).per(5)
      # @conversations = Conversation.page(params[:conversation_page]).per(5)
      current_user = @user  
    elsif current_user != @user
      @repositories = @user.repositories.page(params[:repository_page]).per(5).order("created_at desc")
      ## 以下、ユーザが非公開設定している場合のリダイレクト先
      # redirect_to(repositories_path, danger:"権限がありません") if @user.status == closed
    end
    # set_userで定義した@user = User.find(params[:id])のこと
    # ログインしているユーザーが他のユーザーのページを表示しようとした場合、
    # current_user != @user となり、redirect_to(tasks_path, danger:"権限がありません")
    # によってタスク一覧ページにリダイレクトされます。
  end

  def edit
    @user = current_user
  end
  
  def update
    if @user.update(user_params)
      redirect_to new_user_session_path, notice: "ユーザー情報が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

#   def destroy
#     @user.destroy
#     redirect_to new_session_path, notice: "ユーザー情報が削除されました"
#   end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :content, :icon)
  end

  def account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :content, :icon])
  end
end
