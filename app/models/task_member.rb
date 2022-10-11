class TaskMember < ApplicationRecord

  belongs_to :member, dependent: :destroy
  belongs_to :task, dependent: :destroy

end
