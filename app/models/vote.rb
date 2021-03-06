class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :user, presence: true, uniqueness: { scope: %i[votable_id votable_type] }
end
