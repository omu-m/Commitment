class TaskMember < ApplicationRecord

  belongs_to :member
  belongs_to :task

  # 承認ステータス
  enum approval_status: { 承認待ち:0, 承認:1, 非承認:2 }

end
