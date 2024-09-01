class Book < ApplicationRecord
  
  belongs_to :library
  belongs_to :author
  belongs_to :language
  belongs_to :subject
  belongs_to :publisher

  has_many :checkouts
  has_many :bookmarks
  has_many :special_books
  has_many :hold_requests

  has_many :students

  validates :isbn, presence: true
  validates :isbn, uniqueness: { case_sensitive: false }
  validates :isbn, length: { minimum: 10 }, allow_blank: true
  validates :title, presence: true
  validates :title, length: { minimum: 5 }
  validates :author_id, presence: true
  validates :publisher_id, presence: true
  validates :edition, presence: true
  validates :language_id, presence: true
  validates :subject_id, presence: true
  validates :library_id, presence: true
  validates :publication_date, presence: true
  validates :summary, presence: true
  validates :summary, length: { minimum: 50 }
  validates :count, presence: true
  
  mount_uploader :cover, CoverUploader

  scope :by_student_university, ->(student) {
    where(library_id: Library.select(:id).where(university: student.university_id))
  }

  scope :ordered_by_title, -> { order(:title) }

  scope :not_from_student_university, ->(student) {
    where.not(library_id: Library.select(:id).where(university: student.university_id))
  }

  scope :search_books_for_student, ->(student, search_by, search_term) {
    by_student_university(student)
      .search_by_parameter_student(search_by, search_term)
      .order(:title)
  }

  scope :search_books_all_for_student, ->(student, search_by, search_term) {
    not_from_student_university(student)
      .search_by_parameter_student(search_by, search_term)
      .order(:title)
  }

  scope :search_by_parameter_student, ->(search_by, search_term) {
    
      case search_by
      when 'title'
        where("LOWER(title) LIKE ?", "%#{search_term.downcase}%")
      when 'authors'
        joins(:author).where("LOWER(authors.name) LIKE ?", "%#{search_term.downcase}%")
      when 'publisher'
        joins(:publisher).where("LOWER(publishers.name) LIKE ?", "%#{search_term.downcase}%")
      when 'subject'
        joins(:subject).where("LOWER(subjects.name) LIKE ?", "%#{search_term.downcase}%")
      else
        where(nil).none
      end
  }

  scope :search_by_parameter_admin, -> (parametro, search_by) {
    case search_by
    when 'title'
      where("LOWER(title) LIKE ?", "%#{parametro.downcase}%")
    when 'author'
      joins(:author).where("LOWER(authors.name) LIKE ?", "%#{parametro.downcase}%")
    when 'publisher'
      joins(:publisher).where("LOWER(publishers.name) LIKE ?", "%#{parametro.downcase}%")
    when 'subject'
      joins(:subject).where("LOWER(subjects.name) LIKE ?", "%#{parametro.downcase}%")
    else
      where(nil).none
    end
  }

  scope :search_by_parameter_librarian, -> (parametro, search_by, library_id) {
    case search_by
    when 'title'
      where("LOWER(title) LIKE ? AND library_id = ?", "%#{parametro.downcase}%", library_id)
    when 'author'
      joins(:author).where("LOWER(authors.name) LIKE ? AND library_id = ?", "%#{parametro.downcase}%", library_id)
    when 'publisher'
      joins(:publisher).where("LOWER(publishers.name) LIKE ? AND library_id = ?", "%#{parametro.downcase}%", library_id)
    when 'subject'
      joins(:subject).where("LOWER(subjects.name) LIKE ? AND library_id = ?", "%#{parametro.downcase}%", library_id)
    else
      where(nil).none
    end
  }

  scope :from_library, ->(library_id) { joins(:library).where(libraries: { id: library_id }) }

  scope :checked_out_admin, -> { joins(:checkouts).where(checkouts: { return_date: nil }) }
  scope :checked_out, -> (library_id) { 
    joins(:checkouts, :library).where(checkouts: { return_date: nil }, libraries: { id: library_id }) 
  }
  
  scope :bookmarked_by, -> (student_id) { joins(:bookmarks).where(bookmarks: { student_id: student_id }) }

  scope :checked_out_by, -> (student_id) { joins(:checkouts).where(checkouts: { student_id: student_id, return_date: nil }) }

  scope :hold_requested_by, -> (student_id) { joins(:hold_requests).where(hold_requests: { student_id: student_id }) }

  scope :special_book_by, -> (student_id) { joins(:special_books).where(special_books: { student_id: student_id }) }

  scope :special_collection, -> { where(special_collection: true) }

  def available_for_checkout?(current_student)
    if special_collection?
      !SpecialBook.exists?(student_id: current_student.id, book_id: id)
    else
      count.positive? && !Checkout.exists?(student_id: current_student.id, book_id: id, return_date: nil)
    end
  end

  def special_collection?
    special_collection == true
  end

end


