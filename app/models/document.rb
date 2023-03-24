class Document < ApplicationRecord
  belongs_to :user
  belongs_to :branch

  has_paper_trail
  # paper_trailを使用してバージョン記録・追跡。
  # 他のテーブルにも適用可能

end
