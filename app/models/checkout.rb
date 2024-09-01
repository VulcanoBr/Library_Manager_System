class Checkout < ApplicationRecord

  belongs_to :student
  belongs_to :book

  scope :pending_for_student, ->(student_id) { where(student_id: student_id, return_date: nil) }

  scope :overdue_fines, -> { pluck(:overdue_fines).first }

  scope :returned_books, ->(book_id) { where.not(return_date: nil).where(book_id: book_id) }

  scope :overdue_books, ->(library_id) { 
    joins(:book).joins(book: :library).where('checkouts.return_date IS NULL AND libraries.id = ?', library_id)
  }

  scope :overdue, -> { where(return_date: nil) }

  scope :checkedout_books_and_students_admin, -> { 
    select(:'students.id',:'students.name',:'students.email',:'students.education_level_id',:'students.university_id',:'books.isbn',
            :'books.title',:'books.author_id',:issue_date,:return_date,:'books.language_id',:'books.publisher_id',
            :'books.edition',:'books.subject_id',:'books.summary',:'books.special_collection').joins(:student).joins(:book) 
  }

  scope :checkedout_books_and_students, -> (library_id = nil) {
      if library_id
        select(:'students.id', :'students.name', :'students.email', :'students.education_level_id', :'students.university_id', :'books.isbn', :'books.title', :'books.author_id', :'books.library_id', :issue_date, :return_date, :'books.language_id', :'books.publisher_id', :'books.edition', :'books.subject_id', :'books.summary', :'books.special_collection').joins(:student).joins(:book).where(books: { library_id: library_id })
      else
        select(:'students.id', :'students.name', :'students.email', :'students.education_level_id', :'students.university_id', :'books.isbn', :'books.title', :'books.author_id', :issue_date, :return_date, :'books.language_id', :'books.publisher_id', :'books.edition', :'books.subject_id', :'books.summary', :'books.special_collection').joins(:student).joins(:book)
      end
  }

    scope :special_book_not_checked_out?, ->(student_id, book_id) {
      joins(:book).where(student_id: student_id, books: { id: book_id }, return_date: nil)
    }
  
    scope :checked_out_books_count, ->(student_id) {
      where(student_id: student_id, return_date: nil).count
    }

  def self.find_by_student_and_book(student_id, book_id)
      find_by(student_id: student_id, book_id: book_id, return_date: nil)
  end
  
  def self.return_book(student_id, book)
      checkout = find_by_student_and_book(student_id, book.id)
  
      if checkout.present?
        process_book_return(checkout)
        return { success: true, message: "Book successfully returned !!!" }
      else
        return { success: true, message: "Book is not successfully returned" }
      end
  end

  def self.handle_hold_request(student_id, book)
    checkout = find_by_student_and_book(student_id, book.id)

    if checkout.present?
      hold_request = HoldRequest.find_by(book_id: book.id)
      
      if hold_request.nil?
        process_book_return(checkout)
      else
        checkout.update(return_date: Date.today)
        create_new_checkout(hold_request)
        send_checkout_email(hold_request)
        hold_request.destroy
      end
      return { success: true, message: "Book successfully returned !!!" }
    end
  end

  def self.process_book_return(checkout)
    checkout.update(return_date: Date.today)
    checkout.book.increment!(:count)
    checkout.book.save!
    user = Student.find(checkout.student_id)
    UserMailer.returnbook_email(user, checkout.book).deliver_now
  end

  def self.process_regular_checkout(student_id, book)
    checkout = find_by_student_and_book(student_id, book.id)
    issue_date = Date.today

    if checkout.nil?
      borrow_limit = Library.find(book.library_id).borrow_limit
      expected_return_date = issue_date.advance(days: borrow_limit)

      create!(
        student_id: student_id,
        book_id: book.id,
        issue_date: issue_date,
        expected_return_date: expected_return_date,
        return_date: nil,
        validity: borrow_limit
      )

      book.decrement!(:count)
      UserMailer.checkout_email(Student.find(student_id), book).deliver_now
    end
  end

  private

  def self.create_new_checkout(hold_request)
    issue_date = Date.today
    borrow_limit = Library.find(book.library_id).borrow_limit
    expected_return_date = issue_date.advance(days: borrow_limit)
    new_checkout = new(
      student_id: hold_request.student_id,
      book_id: hold_request.book_id,
      issue_date: issue_date,
      expected_return_date: expected_return_date,
      return_date: nil,
      validity: borrow_limit
    )
    new_checkout.save!
  end

  def self.send_checkout_email(hold_request)
    user = Student.find(hold_request.student_id)
    UserMailer.checkout_email(user, hold_request.book).deliver_now
  end

end

