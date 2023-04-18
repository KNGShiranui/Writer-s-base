class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :conversation_id, :user_id
  validates :content, presence: true

  scope :unread, -> { where(read: false) } #未読のみを抽出するクエリ
  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end