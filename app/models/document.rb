class Document < ApplicationRecord
  require 'damerau-levenshtein'

  belongs_to :user
  belongs_to :branch
  has_one :commit, dependent: :destroy
  accepts_nested_attributes_for :commit, allow_destroy: true, reject_if: :all_blank
  # , update_only: true  # commitかcommitsかどっち？
  # TODO:has_many :versionsのような記載はいらない？
  has_paper_trail
  # paper_trailを使用してバージョン記録・追跡。
  # 他のテーブルにも適用可能
  has_many_attached :embeds  # 1対多(複数枚画像投稿)で関連付けるという宣言
  # Active Storageを使って、embedsという名前で1対多の関係（複数の画像投稿）を持つことを宣言
  # embedsは、このコード内では明示的に定義されていないが、has_many_attached :embedsという宣言（has_manyではなくhas_many_attachedであることが大事）
  # によって、embedsという名前で、DocumentモデルとActive Storageで管理されるファイル（画像など）との間に1対多の関係が作られている。
  # つまり、embedsは、このDocumentモデルに添付された複数のファイル（例えば、画像）を表しています。
  ## Active Storageで管理されるファイル（画像など）との間に1対多の関係が作られているのであれば、
  # どこかにbelongs_to: documentのような記載がされている箇所が別ファイルであるということか？
  # ⇒実際には、belongs_to :documentのような記述は別ファイルに存在しない。
  # RailsのActive Storageは、has_many_attachedやhas_one_attachedメソッドを使って、モデルとファイル（画像など）との間に関連付けを行うが、
  # この関連付けは通常のhas_manyやbelongs_toとは異なる方法で実現されている。
  # Active Storageは、2つのテーブル（active_storage_blobsとactive_storage_attachments）を使用して、
  # ファイルのメタデータとそのファイルが関連付けられたモデル間の関連を管理する。
  # active_storage_blobsテーブルにはファイルのメタデータが、active_storage_attachmentsテーブルには関連付け情報が格納される。
  # たとえば、has_many_attached :embedsを使用すると、Active Storageはactive_storage_attachmentsテーブルに、
  # record_type（ここではDocument）、record_id（モデルのID）、name（ここではembeds）、
  # およびblob_id（関連するactive_storage_blobsテーブルのID）といった情報を持つレコードを作成する。
  # これにより、embedsという名前で、Documentモデルとファイルの間に1対多の関係が作られる。
  # has_many_attachedやhas_one_attachedを使用すると、Active Storageは自動的にこの関連付けを処理し、
  # 関連するモデルでファイルにアクセスできるようになる。そのため、belongs_to :documentのような記述は必要ない。
  before_save :set_embeds
  # 保存（save）する前に、set_embedsメソッドを実行するように設定。  

  # FIXME:以下の書き方で機能実装はOK。ただし、バージョン戻る等に不具合。時間がないのでとりあえずコメントアウト。
    def levenshtein_distance_to_previous_version
    require 'damerau-levenshtein'

    previous_version = self.versions.last
    return nil if previous_version.nil?

    reified_version = previous_version.reify
    return nil if reified_version.nil?

    previous_content = previous_version.reify.content
    current_content = self.content

    # FIXME:以下の書き方では不具合が出た
    # dl = DamerauLevenshtein.new(previous_content, current_content)
    # dl.distance
    # 理由:damerau-levenshteinはモジュールであり、newメソッドが定義されていないため、
    # undefined method 'new'が発生。
    DamerauLevenshtein.distance(previous_content, current_content)
  end

  private
  
  scope :official, -> { where(draft: false) } #正規版のみ抽出
  scope :draft, -> { where(draft: true) } #下書きのみ抽出

  def set_embeds
    return if content.blank?
    nokogiri_html = Nokogiri::HTML.parse(content)
    # Nokogiriは、Rubyで使用されるXMLおよびHTMLパーサーライブラリーで、XMLまたはHTMLドキュメントを解析および操作するために使用される。
    # nokogiri_htmlは、Nokogiri::HTML.parseメソッドを使用して、Documentモデルのcontentカラムに格納されたHTML文字列をパースして得られたNokogiriオブジェクトを格納。
    # つまり、この行はcontent カラムに格納されたHTML文字列を解析して、nokogiri_html変数にNokogiriオブジェクトとして格納するために使われる。
    # Nokogiriオブジェクトを使用することで、HTML文書を走査したり、要素を操作したりすることができる。
    ## parseという言葉自体は解析するという意味
    # parseメソッド は、文字列からXMLまたはHTML文書を解析して、解析済みの文書を表すオブジェクトを生成するメソッド。
    # 具体的には、Nokogiri ライブラリーに含まれるメソッドの1つであり、HTMLまたはXML文書の構造を解析し、木構造の階層を形成するために使用される。
    # たとえば、Nokogiri::HTML.parse(content) は、HTML形式の content 文字列を解析して、 Nokogiri オブジェクトを生成する。
    # このオブジェクトには、HTMLドキュメントの要素、属性、テキストノードなどが含まれる。
    # 生成された Nokogiri オブジェクトは、XMLまたはHTML文書の解析と操作に使用される。
    # parse メソッドは、Nokogiri ライブラリーだけでなく、Rubyの標準ライブラリーにも含まれている。
    # たとえば、JSON形式の文字列を解析するためには、JSON.parse メソッドを使用する。
    # parse メソッドは、文字列から構造化されたデータを生成するための一般的な手段として使用される。
    sgids = nokogiri_html.css('figure').map do |figure|
      # nokogiri_htmlオブジェクトからfigureタグを持つ要素を取得し、それらを走査してsgids配列に結果を格納。
      trix_attachment = JSON.parse(figure['data-trix-attachment'])
      trix_attachment['sgid']
    end
    blobs = sgids.map { |sgid| ActiveStorage::Blob.find_signed(sgid) }
    # ActiveStorage::Blobオブジェクトは、RailsのActive Storageでファイル（画像、動画、ドキュメントなど）のメタデータを表すオブジェクト。
    # Active Storageは、アプリケーションのモデルとファイルを関連付けるためのフレームワークであり、
    # さまざまなストレージサービス（ローカルディスク、Amazon S3、Google Cloud Storageなど）にファイルを保存できる。
    # ActiveStorage::Blobオブジェクトには、ファイル名、コンテンツタイプ（MIMEタイプ）、ファイルサイズ、
    # チェックサムなどのメタデータが格納されており、それを使ってファイルにアクセスしたり、ダウンロードしたり、表示したりすることができる。
    self.embeds = blobs - embeds.map(&:blob)
    # 現在のembedsに紐づくblobと、取得したblobsの差分を、self.embedsに設定している。
  end
end

