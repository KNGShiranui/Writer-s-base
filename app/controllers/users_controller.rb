class UsersController < ApplicationController
  before_action :set_user, only: %i(edit update show destroy)
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :current_user
  
  def index
    @q = User.ransack(params[:q])
    @filtered_users = @q.result(distinct: true).where.not(id: current_user.id)
    @users = Kaminari.paginate_array(@filtered_users).page(params[:page]).per(5)
    @count = @users.total_count
  end

  def new
    redirect_to user_path(current_user) if user_signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      current_user = @user
      redirect_to new_user_session_path, notice: "ユーザー登録が完了しました" 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def show
    if current_user == @user
      @repositories = current_user.repositories.page(params[:repository_page]).per(5).order("created_at desc")
      @conversations = Conversation.where("(sender_id = ?) OR (recipient_id = ?)", current_user.id, current_user.id).page(params[:conversation_page]).per(5)
      current_user = @user
      @followers = @user.followers.page(params[:page]).per(5)
      @users = @user.following.page(params[:page]).per(5)
    elsif current_user != @user
      @repositories = @user.repositories.page(params[:repository_page]).per(5).order("created_at desc")
      @followers = @user.followers.page(params[:page]).per(5)
      @users = @user.following.page(params[:page]).per(5)
    end
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :content, :icon, :points)
  end

  def account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :content, :icon])
  end
end
