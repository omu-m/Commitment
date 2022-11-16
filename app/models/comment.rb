class Comment < ApplicationRecord

  belongs_to :subtask
  belongs_to :member
  # 返信対象となるコメントのid
  belongs_to :parent, class_name: "Comment", optional: true

  # 返信されたコメントが格納
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 300 }

  # 通知
  has_one :activity, as: :target, dependent: :destroy

  def create_activities(task, action, visitor_id, visited_id)
    Activity.create!(
        target: task,
        action: action,
        visitor_id: visitor_id,
        visited_id: visited_id
      )
  end

end
