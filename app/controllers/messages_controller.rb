class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
    # どの会話（チャットルーム）でなされているメッセージなのか？を取得する処理
  end
  before_action :authorized_user, only: [:index, :create]

  def index
    # 一つ一つの部分で何をしているかの理解をわかりやすくするために
    # このような記載にしていますが、実戦で用いるのには少々冗長なコード
    # 要リファクタリング
    @messages = @conversation.messages
    if @messages.length > 10
      # メッセージが10件以上ある場合
      @over_ten = true
      @messages = Message.where(id: @messages[-10..-1].pluck(:id))
      # @messages[-10..-1]のような形でmessageの配列を取り出してしまうと、
      # RailsのDB操作の機能を持ったActiveRecord_Relationというクラスが、
      # ただのArrayクラスへと変換されてしまう（[-10..-1]というメソッドの処理で返却される値は配列である）
      # ため、whereなどのメソッドが使用できなくなってしまいます
      # （whereはDB操作の機能を持ったActiveRecordのクラスでなければ使えないメソッドのため）。
      # そのため、直近で登録されたメッセージの10件のidを取得し、そのidのmessageの配列を
      # whereメソッドで取得するという、少々回りくどい操作をここでは行なっています。
    end
  
    if params[:m]
      # params[:m]の意味。link_toにオプションで追記するクエリパラメータ
      # ここでは、params[:m]というパラメータをチェックした時、
      # そこに値があれば（trueであれば）その下の二行を実行するという意味
      @over_ten = false
      @messages = @conversation.messages
    end
  
    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end
  
    @messages = @messages.order(:created_at)
    @message = @conversation.messages.build
    # buildはnewとほぼ同じ内容の処理をしますが、慣習的に「すでにアソシエーションしてあるインスタンスの生成」
    # ということを表す。上記のような「これはピカピカの状態のインスタンスではなく、既にアソシエーションで他の
    # ものと紐づけられているインスタンスである」ということを表したい記述の場合は、newではなくbuildが使われる
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
  ## 以下のコードとbefore_action :authorized_user, only: [:index, :create]で当事者しか
  # 閲覧と送信ができなくなっている。
  def authorized_user
    unless @conversation.sender_id == current_user.id || @conversation.recipient_id == current_user.id
      flash[:alert] = "アクセス権限がありません。"
      redirect_to root_path
    end
  end
end