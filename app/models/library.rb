class Library < ApplicationRecord

  belongs_to :university
  has_many :librarians
  has_many :special_books

  validates :name, presence: true
  validates :name,  uniqueness: { case_sensitive: false }
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :university_id, presence: true
  validates :location, presence: true
  validates :borrow_limit, presence: true
  validates :borrow_limit, numericality: { greater_than: 0, message: "deve ser maior que zero" }
  validates :overdue_fines, presence: true
  validates :overdue_fines, numericality: { greater_than: 0, message: "deve ser maior que zero" }
  
  
  scope :ordered_by_name, -> { order(:name) }

  scope :overdue_fines, -> { pluck(:overdue_fines).first }
  
end
