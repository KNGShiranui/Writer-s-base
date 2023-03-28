class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # devise_controller? はDeviseが提供するヘルパーメソッド。
  # 現在のコントローラーがDeviseのコントローラーである場合にtrueを返す。
  # before_action フィルターに if: :devise_controller? を指定することで、
  # Deviseのコントローラーでのみ configure_permitted_parameters メソッドが実行されるようになる。

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    # deviseはdeviseが初期で作るカラムには自動でストロングパラメータの設定をしますが、独自実装したカラムには当然その設定はない
    # そのままそのカラムに値を保存しようとするとストロングパラメータで弾かれてしまう。
    # 上記のような記述をすることで、nameカラムがUserのストロングパラメータに加わり、保存ができるようになる。
  end

  def current_repository
    @current_repository ||= Repository.find_by(id: @repository[:id])
    # セッションログインしているユーザーと、アクセスしようとしているページの作成者（ユーザー）が一致するか照合するための前工程
    # session[:user_id]がnilならnew_session_pathへリダイレクトされる
    # この過程はセッションのnewとcreateアクションには適用されない
    # current_userがアクセス権限のある人かどうかはensure_correct_userで確認される。
  end

  helper_method :current_repository
  # helper_method :current_userを記載しないとapplication_controllerに記載していてもcurrent_userメソッドをローカル変数の
  # ようにuserのshowページで用いることはできない。
  # というのも、helperはビューに適用されるのが前提だが、controllerに記載されているメソッドはそのままではビューで使用するという
  # 前提で設計されていない。使用するには上記のようにしてビューでもhelperとして使うと明示する必要あり
end
