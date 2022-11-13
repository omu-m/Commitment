class Association < ApplicationRecord

  def self.create_notification_favotite!(current_member, member_id, id)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and association_id = ? and action = ? ", current_member.id, member_id, id, "favorite"])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_member.active_notifications.new(
        association_id: id,
        visitor_id: current_member.id,
        visited_id: member_id,
        action: "favorite"
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.check = true
      end
      notification.save! if notification.valid?
    end
  end
end
