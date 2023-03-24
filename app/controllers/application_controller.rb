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
end
