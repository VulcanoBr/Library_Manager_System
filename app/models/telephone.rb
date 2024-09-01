class Telephone < ApplicationRecord

  belongs_to :university

  validates :phone, presence: true
  validates :contact, presence: true
  validates :email_contact, presence: true
  validates :email_contact, uniqueness: { case_sensitive: false }
  validates_format_of :email_contact, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  
end
