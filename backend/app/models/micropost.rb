# frozen_string_literal: true

class Micropost < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many_attached :image
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liked_user, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  # スコープ
  default_scope -> { order(created_at: :desc) }
  # バリデーション
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: '正しい画像形式でお願いします' },
                    size: { less_than: 5.megabytes,
                            message: '5MB以下でお願いします' }

  # いいねの通知を作成する
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    notification_liked = Notification.where(['visitor_id = ? AND visited_id = ? AND micropost_id = ? AND action = ? ',
                                             current_user.id, user_id, id, 'like'])
    if notification_liked.blank?
      notification = current_user.active_notifications.new(
        visited_id: user_id,
        micropost_id: id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      notification.checked = true if notification.visitor_id == notification.visited_id
      notification.save if notification.valid?
    end
  end

  # コメントの通知を作成する
  def create_notification_comment!(current_user, comment_id)
    notification = current_user.active_notifications.new(
      visited_id: user_id,
      micropost_id: id,
      comment_id: comment_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
