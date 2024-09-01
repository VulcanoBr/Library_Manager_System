class SpecialBook < ApplicationRecord
  belongs_to :student
  belongs_to :book

  scope :for_library, ->(library_id) {
    joins(book: :library)
      .where('books.library_id = ?', library_id).load
  }

  scope :by_book_and_student, -> (student_id, book_id) { where(student_id: student_id, book_id: book_id) }

  def self.create_request(student_id, book_id)
    create(student_id: student_id, book_id: book_id)
  end

end
