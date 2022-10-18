class Comment < ApplicationRecord

  belongs_to :subtask
  belongs_to :member

  validates :comment, presence: true, length: { maximum: 300 }

end
