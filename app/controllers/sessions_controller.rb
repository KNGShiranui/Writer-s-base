# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  def guest_sign_in
    sign_in User.guest
    user = User.guest
    redirect_to after_sign_in_path_for(user), notice: 'ログインしました。'
  end

  def guest_admin_sign_in
    sign_in User.guest_admin
    user = User.guest_admin
    redirect_to after_sign_in_path_for(user), notice: 'ログインしました。'
  end
end
