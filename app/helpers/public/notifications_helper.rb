module Public::NotificationsHelper

  def notification_form(notification)
    @comment = nil
    case notification.action
      when "favorite" then
        "にいいね！しました"
      when "comment" then
        @comment = Comment.find_by(id:notification.comment_id)&.content
        "にコメントしました"
    end
  end
end
