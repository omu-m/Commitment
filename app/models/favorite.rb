class Favorite < ApplicationRecord

  belongs_to :subtask
  belongs_to :member

  # 通知機能
  def create_activities(task, action, visitor_id, visited_id)
    Activity.create!(
        target: task,
        action: action,
        visitor_id: visitor_id,
        visited_id: visited_id
      )
  end
end
