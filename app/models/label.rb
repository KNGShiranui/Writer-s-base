class Label < ApplicationRecord
  has_many :repository_labels
  has_many :repositories, through: :repository_labels
end
