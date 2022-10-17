class Favorite < ApplicationRecord

  belongs_to :subtask
  belongs_to :member

end
