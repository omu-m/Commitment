class Activity < ApplicationRecord

  belongs_to :target, polymorphic: true

end
