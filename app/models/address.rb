class Address < ApplicationRecord

  belongs_to :university

  validates :street, presence: true
  validates :neighborhood, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :country, presence: true

end
