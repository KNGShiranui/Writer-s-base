class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_repository_id

  protected

  def after_sign_in_path_for(resource)
    ## TODO:↓のコードを有効にすると、ログインボーナスは一日一回という条件が付けられる
    if resource.last_login_bonus_date.nil? || resource.last_login_bonus_date < Date.today
      # ランダムなログインボーナスを生成
      login_bonus = generate_login_bonus
      # ユーザーのポイントにログインボーナスを追加
      resource.update(points: resource.points + login_bonus, last_login_bonus_date: Date.today)
      # ログインボーナスを通知
      flash[:success] = "ログインボーナス#{login_bonus} ポイント獲得！"
    end
    user_path(current_user) 
  end

  def generate_login_bonus
    # ランダムなログインボーナスを 1 から 5 の範囲で生成  
    rand(1..5)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name content icon])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name content icon])
  end

  def current_repository
    @current_repository ||= Repository.find_by(id: @repository[:id])
  end

  ## 以下2メソッドはissue関係のcancancan関係のための記述（結局未使用）
  def set_current_repository_id
    Thread.current[:current_repository_id] = params[:repository_id]
  end

  def current_repository_id
    Thread.current[:current_repository_id]
  end

  ## 以下2メソッドはdocument関係のcancancan用（TODO:未完成）
  def set_current_branch_id
    Thread.current[:current_branch_id] = params[:branch_id]
  end

  # Thread.currentは、現在実行中のスレッドに関する情報を持っているオブジェクト。
  def current_branch_id
    Thread.current[:current_branch_id]
  end

  helper_method :current_repository, :current_branch
end
