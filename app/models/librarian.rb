class Librarian < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :library

  validates :name, presence: true
  validates :library_id, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }

  scope :ordered_by_name, -> { order(:name) }
  
end
