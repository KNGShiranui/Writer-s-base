# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  def guest_sign_in
    sign_in User.guest
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  def guest_admin_sign_in
    sign_in User.guest_admin
    redirect_to root_path, notice: 'ゲスト管理者としてログインしました。'
  end
end
