class TaskFavorite < ApplicationRecord

  belongs_to :task
  belongs_to :member

end
