class Task < ApplicationRecord

  has_many :task_members, dependent: :destroy
  has_many :members, through: :task_members, dependent: :destroy
  has_many :subtasks, dependent: :destroy

end
