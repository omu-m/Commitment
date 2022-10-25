class Comment < ApplicationRecord

  belongs_to :subtask
  belongs_to :member
  # 返信対象となるコメントのid
  belongs_to :parent, class_name: "Comment", optional: true

  # 返信されたコメントが格納
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 300 }

end
