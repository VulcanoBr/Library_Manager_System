class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :university
  belongs_to :education_level

  has_many :checkouts
  has_many :bookmarks
  has_many :special_books
  has_many :hold_requests

  has_many :books
  
  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :education_level_id, presence: true
  validates :university_id, presence: true
  validates :max_book_allowed, presence: true
  validates :max_book_allowed, numericality: { greater_than: 0, message: "deve ser maior que zero" }
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }

  scope :ordered_by_name, -> { order(:name) }
  
end
