class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_user, only: [:index, :create]

  # これややこしい。注意。
  # この修正により、sender_idまたはrecipient_idがログインユーザーのidと一致する会話を取得するように
  # なります。これで他のユーザー同士のconversationへのアクセスが制限されるはずです。
  def index
    @conversations = Conversation.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id).page(params[:page]).per(5)    
    # この行では、Conversationモデルからデータを取得する際に、whereメソッドを使って特定の条件を満たす
    # レコードを絞り込んでいます。whereメソッドの引数には、条件式を含む文字列と、プレースホルダーに対応
    # する値を渡しています。条件式では、sender_idがログインユーザーのidと等しいか、またはrecipient_id
    # がログインユーザーのidと等しいかのいずれかを満たすレコードを絞り込んでいます。
    # ?はプレースホルダーと呼ばれ、文字列内で後から値を埋め込むための仮の位置を示します。
    # この場合、2つのプレースホルダーがあります。
    # プレースホルダーに埋め込む値は、whereメソッドの引数として後ろに続けて渡しています。
    # ここでは、current_user.idを2回渡しています。これにより、条件式内の?がログインユーザーのidに
    # 置き換わります。
    # 結果として、このコードはログインユーザーが送信者（sender_id）または受信者（recipient_id）
    # である会話を取得します。他のユーザー間の会話は取得されません。
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
      flash[:alert] = "アクセス権限がありません。"
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