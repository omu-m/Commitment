class TaskMember < ApplicationRecord

  belongs_to :member
  belongs_to :task

  # 承認ステータス
  enum approval_status: { before_participation:0, approval_pending: 1, approval: 2, denial_by_owner: 3, denial_by_member: 4 }

end
