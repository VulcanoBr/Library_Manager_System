class HoldRequest < ApplicationRecord
  belongs_to :student
  belongs_to :book

  scope :for_library, ->(library_id) {
    joins(book: :library)
      .where('books.library_id = ?', library_id)
    }
  scope :by_book, -> (student_id, book_id) { where(student_id: student_id, book_id: book_id) }  #-> (book_id) { where(book_id: book_id) }

  def self.create_request(student_id, book_id)
    create(student_id: student_id, book_id: book_id)
  end
end
