class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_user, only: [:index, :create]

  def index
    @conversations = Conversation.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id).page(params[:page]).per(5)    
    # whereメソッドを使って特定の条件を満たすレコードを絞り込み。
    # whereメソッドの引数には、条件式を含む文字列と、プレースホルダーに対応する値を渡している。
    end
  

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    if authorized_user
      redirect_to conversation_messages_path(@conversation)
    else
      flash[:alert] = t("conversations.not_authorized")
      redirect_to root_path
    end
  end

  private

  def authorized_user
    params[:sender_id].to_i == current_user.id || params[:recipient_id].to_i == current_user.id
  end

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end