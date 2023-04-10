class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # devise_controller? はDeviseが提供するヘルパーメソッド。
  # 現在のコントローラーがDeviseのコントローラーである場合にtrueを返す。
  # before_action フィルターに if: :devise_controller? を指定することで、
  # Deviseのコントローラーでのみ configure_permitted_parameters メソッドが実行されるようになる。
  before_action :set_current_repository_id

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

  # def current_branch
  #   @current_branch ||= Branch.find_by(id: @repository[:id])
  # end

  # def current_issue
  #   @current_issue ||= Issue.find_by(id: @repository[:id])
  # end

  def after_sign_in_path_for(resource)
    # binding.pry
    user_path(resource)
  end

  ## 以下2メソッドはissue関係のcancancan関係のための記述（issues_controller、ability.rb、application_controllerに記載あり
  ## ややこしいので気を付けて！
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

  def current_branch_id
    Thread.current[:current_branch_id]
  end
  # Thread.current は、現在実行中のスレッドに関する情報を持っているオブジェクトです。
  # スレッドは、プログラムの実行を並行して行うための概念で、それぞれのスレッドは独立して実行されます。
  # Ruby on Rails のリクエストは、通常、各リクエストごとに異なるスレッドで実行されます。
  # Thread.current[:current_branch_id] は、現在実行中のスレッド内で一時的にデータを保持するために
  # 使用されるハッシュです。この例では、set_current_branch_id メソッドを使って、current_branch_id
  # キーに params[:branch_id] を保存しています。
  # Thread.current を使用する主な理由は、コントローラから ability.rb へパラメータを渡すためです。
  # ability.rb は CanCanCan gem で使用されるため、直接パラメータを受け取ることができません。
  # Thread.current を使用することで、コントローラから ability.rb へ間接的にデータを渡すことができます。
  # このデータは、リクエストが終了するとクリアされるため、他のリクエストに影響を与えることはありません。

  helper_method :current_repository, :current_branch
  # helper_method :current_userを記載しないとapplication_controllerに記載していてもcurrent_userメソッドをローカル変数の
  # ようにuserのshowページで用いることはできない。
  # というのも、helperはビューに適用されるのが前提だが、controllerに記載されているメソッドはそのままではビューで使用するという
  # 前提で設計されていない。使用するには上記のようにしてビューでもhelperとして使うと明示する必要あり
end
