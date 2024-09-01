class Transaction < ApplicationRecord

  scope :requested_by_student, -> (isbn, email) { where(isbn: isbn, email: email, request: true) }

end
