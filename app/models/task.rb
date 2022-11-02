class Task < ApplicationRecord

  extend OrderAsSpecified

  has_many :task_members, dependent: :destroy
  has_many :request_tasks, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :members, through: :task_members
  has_many :task_favorites, dependent: :destroy

  validates :task_title, presence: true, length: { maximum: 30 }
  validates :task_content, presence: true

  has_one_attached :image

  # 承認ステータス
  enum approval_status: { 承認待ち:0, 承認:1, 非承認:2 }

  # いいねボタンはいいねしている状態としていない状態によってアクションが変わる。
  def task_favorited_by?(member)
    task_favorites.where(member_id: member.id).exists?
  end
end
