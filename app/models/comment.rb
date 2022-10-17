class Comment < ApplicationRecord

  belongs_to :subtasuk
  belongs_to :member

  validates :comment, presence: true, length: { maximum: 300 }

end
