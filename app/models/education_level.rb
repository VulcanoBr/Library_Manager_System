class EducationLevel < ApplicationRecord

  has_many :students

  validates :name, presence: true
  validates :name,  uniqueness: { case_sensitive: false }

  scope :ordered_by_name, -> { order(:name) }

end
