class Label < ApplicationRecord
  has_many :repository_labels, dependent: :destroy
  has_many :repositories, through: :repository_labels
end
