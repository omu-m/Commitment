class TaskMember < ApplicationRecord

  belongs_to :member
  belongs_to :task

  # 承認ステータス
  enum approval_status: { approval_pending: 0, approval: 1, non_approval: 2 }

end
