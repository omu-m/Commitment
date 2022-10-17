class Task < ApplicationRecord

  has_many :task_members, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :members, through: :task_members

  validates :task_title, presence: true
  validates :task_content, presence: true

  has_one_attached :image
end
