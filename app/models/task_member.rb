class TaskMember < ApplicationRecord

  belongs_to :member
  belongs_to :task

end
