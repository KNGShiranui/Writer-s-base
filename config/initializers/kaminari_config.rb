Kaminari.configure do |config|
  config.default_per_page = 5
  # デフォルトで1ページに表示するアイテムの数を5に設定します。
  # config.max_per_page = nil
  config.window = 4
  # 現在のページの前後に表示するページ数を4に設定します。
  # これにより、現在のページの前後に最大4つのページ番号が表示されます。
  config.outer_window = 1
  # 最初(First)と最後(Last)のページから、左右何ページ分のリンクを表示させるか
  ## config.left = 0
  # 最初(First)のページから、何ページ分のリンクを表示させるか(デフォルトは0件)
  ## config.right = 0
  # 最終(Last)ページから、何ページ分のリンクを表示させるか(デフォルトは0件)
  ## config.page_method_name = :page
  # デフォルトは:page
  ## config.param_name = :page
  # デフォルトは:page
end
