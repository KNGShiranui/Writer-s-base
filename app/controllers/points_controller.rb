# app/controllers/points_controller.rb
class PointsController < ApplicationController
  before_action :authenticate_user!

  def new
    if params[:receiver_id]
      @user = User.find(params[:receiver_id])
    else
      @users = User.where.not(id: current_user.id)
    end
  end

  def create
    receiver = User.find(params[:receiver_id])
    amount = params[:amount].to_i
    # binding.pry
    if current_user.send_points(receiver, amount)
      # チャットルーム情報の取得・チャットルーム呼び出しまたは作成
      conversation = Conversation.between(current_user.id, receiver.id).first
      if conversation.nil?
        conversation = Conversation.create(sender_id: current_user.id, recipient_id: receiver.id)
      end
      # 送り先ユーザへのメッセージの作成
      message = Message.new(
        conversation_id: conversation.id,
        user_id: current_user.id,
        content: "#{current_user.name}があなたに#{amount}ポイントプレゼントしました。"
      )
      # 通知
      if message.save
        flash[:success] = "#{amount}ポイントを#{receiver.name}に送信しました。"
        redirect_to user_path(current_user)
      else
        flash[:alert] = "ポイントの送信に失敗しました。"
        redirect_to new_point_path
      end
    else
      flash[:alert] = "ポイントの送信に失敗しました。"
      redirect_to new_point_path
    end
  end
end
