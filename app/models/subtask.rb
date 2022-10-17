class Subtask < ApplicationRecord

  belongs_to :task
  belongs_to :member

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :subtask_content, presence: true

  has_one_attached :image

  # 進捗ステータス
  enum progress_status: { 未完了:0, 処理中:1, 処理済み:2, 完了:3 }

  # いいねボタンはいいねしている状態としていない状態によってアクションが変わる。
  def favorited_by?(member)
    favorites.where(member_id: member.id).exists?
  end

end
