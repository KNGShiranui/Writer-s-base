class Document < ApplicationRecord
  require 'damerau-levenshtein'

  belongs_to :user
  belongs_to :branch
  has_one :commit, dependent: :destroy
  has_many_attached :embeds
  accepts_nested_attributes_for :commit, allow_destroy: true, reject_if: :all_blank

  # paper_trailを使用してバージョン記録・追跡。  
  has_paper_trail

  before_save :set_embeds

  def levenshtein_distance_to_previous_version
    require 'damerau-levenshtein'

    previous_version = self.versions.last
    return nil if previous_version.nil?

    reified_version = previous_version.reify
    return nil if reified_version.nil?

    previous_content = previous_version.reify.content
    current_content = self.content

    DamerauLevenshtein.distance(previous_content, current_content)
  end

  private
  
  scope :official, -> { where(draft: false) } #正規版抽出
  scope :draft, -> { where(draft: true) } #下書き抽出

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

