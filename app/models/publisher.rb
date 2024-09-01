class Publisher < ApplicationRecord

  validates :name, presence: true
  validates :name,  uniqueness: { case_sensitive: false }
  validates :website, presence: true
  validates :website, uniqueness: { case_sensitive: false }
  validates :website, format: { with: /\Awww\..+\.com\z/,
                            message: "deve seguir o padrão www. e .com" }
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  scope :ordered_by_name, -> { order(:name) }

end
