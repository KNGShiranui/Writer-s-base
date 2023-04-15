# app/controllers/points_controller.rb
class PointsController < ApplicationController
  before_action :authenticate_user!

  def new
    @users = User.where.not(id: current_user.id)
  end

  def create
    receiver = User.find(params[:receiver_id])
    amount = params[:amount].to_i
binding.pry
    if current_user.send_points(receiver, amount)
      flash[:success] = "#{amount}ポイントを#{receiver.name}に送信しました。"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "ポイントの送信に失敗しました。"
      redirect_to new_point_path
    end
  end
end
