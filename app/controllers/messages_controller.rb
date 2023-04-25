class MessagesController < ApplicationController
  before_action do
    # チャットルーム情報の取得
    @conversation = Conversation.find(params[:conversation_id])
  end
  before_action :authorized_user, only: [:index, :create]

  def index
    # 要リファクタリング
    @messages = @conversation.messages
    if @messages.length > 10
      # メッセージが10件以上ある場合
      @over_ten = true
      @messages = Message.where(id: @messages[-10..-1].pluck(:id))
      # @messages[-10..-1]のような形でmessageの配列を取り出してしまうと、Arrayクラス
      # へと変換されてしまう（[-10..-1]というメソッドの処理で返却される値は配列）ため、
      # whereなどのメソッドが使用できなくなってしまう。そのため、直近で登録されたメッセージ
      # の10件のidを取得し、そのidのmessageの配列をwhereメソッドで取得。
    end

    if params[:m]
      # params[:m]に値があれば（trueであれば）下二行を実行
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end
    @messages = @messages.order(:created_at)
    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      @messages = @conversation.messages
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id)
  end

  def authorized_user
    unless @conversation.sender_id == current_user.id || @conversation.recipient_id == current_user.id
      flash[:alert] = t("messages.not_authorized")
      redirect_to root_path
    end
  end
end