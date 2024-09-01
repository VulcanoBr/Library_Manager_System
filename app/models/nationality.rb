class Nationality < ApplicationRecord

  has_many :authors

  validates :name, presence: true
  validates :name,  uniqueness: { case_sensitive: false }

  scope :ordered_by_name, -> { order(:name) }

end
