class RepositoryLabel < ApplicationRecord
  belongs_to :repository
  belongs_to :label
end
