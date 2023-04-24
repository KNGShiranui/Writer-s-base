class DocumentsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_document, only: %i(show edit update destroy)
  # load_and_authorize_resource

  def index
    @repository = Repository.find(params[:repository_id])
    @branch = @repository.branches.find(params[:branch_id])
    # @documents = Document.all.includes(:user).order(created_at: :desc).page(params[:page])
    @documents = @branch.documents.official.order(created_at: :desc).page(params[:documents_page])
    @document_drafts = @branch.documents.draft.where(user: current_user).order(created_at: :desc).page(params[:document_drafts_page])
  end
  
  def show
    @document = Document.find(params[:id])
    @repository = Repository.find(params[:repository_id]) 
    @branch = Branch.find(params[:branch_id])
    @versions = @document.versions.reorder(created_at: :desc).page(params[:page]).per(5)
    # orderはpapertrailでは使えないらしい。代わりにreorderを使うと成功
    @full_content = params[:full_content] == 'true'   #FIXME:これで続きを読む、をクリックした場合に続きを表示させるようにできる。
    # FIXME:以下はレーベンシュタイン距離の算出用。旧バージョンに戻す部分でエラーが出たのでとりあえずコメントアウト
    @levenshtein_distance = @document.levenshtein_distance_to_previous_version # モデルで定義したメソッドを使用
    
    
    # FIXME:以下、使用しないかもしれない保留ネタ
    # @similar_documents = Document.similar_documents(@document, 10) # 10 is the threshold
    # このコードでは、@similar_documentsに類似したドキュメントを格納。Document.similar_documents(@document, 10)の部分で、
    # @document（現在表示しているドキュメント）と類似性が高いドキュメントを検索。
    # ここでの10は閾値（threshold）を意味する。この閾値はDamerau-Levenshtein距離の最大値で、この値以下の距離を持つドキュメントが類似しているとみなされる。
    # Damerau-Levenshtein距離は、2つの文字列間の編集距離を表す数値。この距離が小さいほど、2つの文字列は類似していると考えられる。
    # この例では、閾値が10なので、Damerau-Levenshtein距離が10以下のドキュメントが類似ドキュメントとしてリストされる。
    # 閾値を変更することで、類似度の判断基準を調整することができる。
  end
  
  def new
    # binding.pry
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
    if current_user.id == @repository.user_id || current_user.id == @branch.repository.user_id
      # @commit = @document.commit.build
      @document = Document.new # これがないせいでcommitの作成ができなくなっていた。
      @commit = @document.build_commit # これによってcommitメッセージ欄を出している。
      # @document = @branch.commit.build
      # has_oneアソシエーションの場合、build_associationメソッドを使う。
      # このメソッドは、関連付けられたモデルの新しいインスタンスをビルドし、現在のモデルに関連付ける。
      # @document.build_commitが正しく動作しているのは、build_commitメソッドがhas_one関連付けで使用されるため。
      # @document.commit.buildの場合、まず@document.commitを実行して、関連するCommitオブジェクトを取得しようとする。
      # しかし、Commitオブジェクトがまだ存在しないため、nilが返される。
      # その後、nilに対してbuildメソッドを呼び出そうとしてNoMethodErrorが発生してしまう。
      # @document.build_commitを使用することで、Documentに関連する新しいCommitオブジェクトをビルドし、エラーを回避できるらしい。
    else
      flash[:alert] = t("documents.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def edit
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
    if current_user.id == @repository.user_id || current_user.id == @branch.repository.user_id
      # @document.build_commit
    else
      flash[:alert] = t("documents.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def create
    @document = Document.new(document_params)
    # @document.user = current_user  # いらんかも
    @repository = Repository.find(params[:document][:repository_id])  # ひとつ前のページであるnewアクションの
    # _formからhidden_fieldでRepository_id渡さないとkokoganilになるはず。んで、次のページ遷移でIDがない旨エラーが出る
    @branch = Branch.find(params[:document][:branch_id])
    # ActiveRecord::Base.transaction do
    # @commit = Commit.create(document_id: @document.id, message: 'Your commit message', user_id: current_user.id, branch_id: @document.branch_id)
    # binding.pry
    if current_user.id == @repository.user_id || current_user.id == @branch.repository.user_id
      respond_to do |format|
        if params[:save_draft] # 下書きボタンを押下した場合
          @document.draft_content = @document.content
          @document.draft = true
          if @document.save
            format.html { redirect_to document_url(@document, repository_id: @repository.id, branch_id: @branch.id), notice: "下書きが保存されました。" }
            format.json { render :show, status: :created, location: @document }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @document.errors, status: :unprocessable_entity }
          end
        else # 通常の投稿ボタンを押下した場合
          if @document.save
            format.html { redirect_to document_url(@document, repository_id: @repository.id, branch_id: @branch.id), notice: t("documents.Document was successfully created") }
            format.json { render :show, status: :created, location: @document }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @document.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      flash[:alert] = t("documents.not_authorized")
      redirect_to repository_url(@repository)
    end
  end

  def update
    # binding.pry
    @repository = Repository.find(params[:document][:repository_id])
    @branch = Branch.find(params[:document][:branch_id])
    ActiveRecord::Base.transaction do
      @commit = Commit.create(document_id: @document.id, user_id: current_user.id, branch_id: @document.branch_id)
      # 上記の記述をifによる条件分岐以降に記載していたため、commitに関する情報がない（user_id, branch_id）と
      # いうエラーが出た。条件分岐の前に記述してやることで解消。
      if current_user.id == @repository.user_id || current_user.id == @branch.repository.user_id
        respond_to do |format|
          # binding.pry
          if @document.update(document_params)
            # binding.pry
            format.html { redirect_to document_url(@document, branch_id: @branch.id, repository_id: @repository.id), notice: t("documents.Document was successfully updated") }
            format.json { render :show, status: :ok, location: @document }
          else
            # binding.pry
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @document.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:alert] = t("documents.not_authorized")
        redirect_to repository_url(@repository)
      end
    end
  end

  def destroy
    @repository = Repository.find(params[:repository_id])
    @branch = Branch.find(params[:branch_id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_path(repository_id: @repository.id, branch_id: @branch.id), notice: t("documents.Document was successfully destroyed") }
      format.json { head :no_content }
    end
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :content, :user_id, :branch_id, commit_attributes:[:id, :message, :user_id, :branch_id])
  end
end
