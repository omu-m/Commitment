class Notification < ApplicationRecord

  default_scope->{order(created_at: :desc)}
  # optional: trueは、nilを許可するもの
  belongs_to :assoc, class_name: "Association", optional: true

  belongs_to :visitor, class_name: "Member", foreign_key: "visitor_id", optional: true
  belongs_to :visited, class_name: "Member", foreign_key: "visited_id", optional: true

end
