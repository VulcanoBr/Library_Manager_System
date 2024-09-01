class Bookmark < ApplicationRecord
  belongs_to :student
  belongs_to :book

  scope :by_student_and_book, ->(student_id, book_id) { where(student_id: student_id, book_id: book_id) }

end
