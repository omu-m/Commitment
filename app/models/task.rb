class Task < ApplicationRecord

  extend OrderAsSpecified

  has_many :task_members, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :members, through: :task_members
  has_many :task_favorites, dependent: :destroy

  validates :task_title, presence: true, length: { maximum: 30 }
  validates :task_content, presence: true

  has_one_attached :image

  # いいねボタンはいいねしている状態としていない状態によってアクションが変わる。
  def task_favorited_by?(member)
    task_favorites.where(member_id: member.id).exists?
  end

  # 検索キーワードが部分一致すれば、その記事を出力する。
  def self.search(keyword)
    where(["task_title like?", "%#{keyword}%"])
  end

  # 通知
  def create_activities(task, action, visitor_id, visited_id)
    Activity.create!(
        target: task,
        action: action,
        visitor_id: visitor_id,
        visited_id: visited_id
      )
  end
end
