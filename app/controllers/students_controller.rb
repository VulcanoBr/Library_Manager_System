class StudentsController < ApplicationController

  before_action :authenticate!
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def authenticate!
    return authenticate_admin! if current_admin
    return authenticate_librarian! if current_librarian
    authenticate_student!
  end

  # GET /students
  # GET /students.json
  def index
	  if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end
  end

  # GET /students/new
  def new
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
		  @student = Student.new
	  end
  end

  # GET /students/1/edit
  def edit
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end
  end

  # POST /students
  # POST /students.json
  def create
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
      @student = Student.new(student_params)

      respond_to do |format|
        if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
        else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    if librarian_signed_in?
        sign_out :student
        redirect_to librarians_path , notice: 'Action not allowed.'
    else
      respond_to do |format|
        if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
        else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    if librarian_signed_in?
        sign_out :student
        redirect_to librarians_path , notice: 'Action not allowed.'
    else
      @student.destroy
      if current_admin.nil?
        respond_to do |format|
          format.html { redirect_to students_path, notice: 'Student was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to show_students_admins_path, notice: 'Student was successfully removed.' }
          format.json { head :no_content }
        end
      end
    end
  end

  def student_libraries_index
    @libraries = Library.ordered_by_name
  end

  def books_students
    @books = Book.by_student_university(current_student)
    @books_all = Book.ordered_by_title.not_from_student_university(current_student)
  end

  def search_book
    return redirect_to(search_book_students_url, notice: "Empty field!") if params[:search].blank?
    @books = Book.search_books_for_student(current_student, params[:search_by], params[:search])
    @books_all = Book.search_books_all_for_student(current_student, params[:search_by], params[:search])
    return redirect_to(books_students_students_url, notice: "No results found for your search #{params[:search]}.") if (@books.nil? && @books_all.nil?)
  end

  def checkout
    @book = Book.find(params[:id])

    if @book.special_collection
      handle_special_collection_checkout
    else
      handle_regular_checkout
    end
  end


  def getBookmarkBooks
    @bookmark = Book.bookmarked_by(params[:student_id])
    @checkout = Book.checked_out_by(params[:student_id])
    hold_request = Book.hold_requested_by(params[:student_id])
    special_book = Book.special_book_by(params[:student_id])
    @request  = hold_request + special_book
  end

  def checkoutdisplay
  end

  def getStudentBookFine
    @checkouts = Checkout.pending_for_student(params[:student_id])
    if !@checkouts.nil?
      @fines = Array.new
      @checkouts.each do |checkout|
        if checkout.issue_date + checkout.validity < Date.today
          delay = (Date.today - checkout.issue_date).to_i - checkout.validity
          fine_per_day = Library.overdue_fines
          @fines.push({:fine_ammount => delay * fine_per_day, :student_id => checkout.student_id, :book_id => checkout.book_id})
        else
          @fines.push({:fine_ammount => 0, :student_id => checkout.student_id, :book_id => checkout.book_id})
        end
      end
    end
  end

  def bookmark
    @book = Book.find(params[:book_id])
    @bookmark = Bookmark.where(:student_id => current_student.id , :book_id => @book.id).first
    if @bookmark.present?
      flash[:notice] = "Book is already bookmarked!!"
      redirect_to books_students_students_path
    else
      @bookmark = Bookmark.new(:student_id => current_student.id , :book_id => params[:book_id])
      @user = current_student
      UserMailer.bookmark_email(@user,@book).deliver_now
      @bookmark.save!
      flash[:notice] = "Book Added to your bookmarks"
      redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
    end

    Transaction.
        find_or_initialize_by(:isbn => @book.isbn , :email => current_student.email).
        update!(:email => current_student.email,:bookmarks => true)
  end

  def unbookmark
    @bookmark = Bookmark.by_student_and_book(current_student.id, params[:book_id]).first
    if @bookmark
      @bookmark.destroy
      flash[:notice] = "Bookmark Removed successfully!!"
      redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
    else
      flash[:notice] = "Bookmark not found!!"
      redirect_to books_students_students_path
    end

  end

  def repealRequest
    @book = Book.find(params[:book_id])
    if @book.special_collection
      @special_book = SpecialBook.by_book_and_student( current_student.id, @book.id ).first
      @special_book.destroy
      flash[:notice] = "Special Book destroy success !!"
    else
      @hold_request = HoldRequest.by_book(current_student.id, @book.id ).first
      @hold_request.destroy
      flash[:notice] = "Hold Request destroy success !!"
    end
    redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
  end

  def returnBook
    @book = Book.find(params[:id])
    if @book.count > 0
      result = Checkout.return_book(current_student.id, @book)
    else
      result = Checkout.handle_hold_request(current_student.id, @book)
    end

    flash[:notice] = result[:message] if result[:message].present?
    redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:email, :identification, :name, :phone, :password, :education_level_id, :university_id, :max_book_allowed)
    end

    def book_params
      params.require(:book).permit(:isbn, :title, :published, :publication_date, :edition,
                      :cover, :summary, :special_collection, :count, :library_id, :subject_id,
                      :language_id, :publisher_id, :author_id)
    end

    def handle_special_collection_checkout
      if special_book_not_checked_out?(@book)
        create_special_book_request
        flash[:notice] = "Book Hold Request Placed !!"
      else
        flash[:notice] = "Book Hold Request Is Already Placed !!"
      end

      redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
    end

    def special_book_not_checked_out?(book)
      Checkout.special_book_not_checked_out?(current_student.id, book.id)
    end

    def create_special_book_request
      SpecialBook.create_request(current_student.id, @book.id)
    end

    def handle_regular_checkout
      if @book.count.positive?
        process_regular_checkout
      else
        handle_book_hold_request
      end
    end

    def process_regular_checkout
      if can_issue_more_books? && book_not_checked_out?(@book)
        Checkout.process_regular_checkout(current_student.id, @book)
        flash[:notice] = "Book Successfully Checked Out"
      elsif !can_issue_more_books?
        flash[:notice] = "You cannot issue more books. Your request has been added to hold request list."
        return redirect_to books_students_students_path
      else
        flash[:notice] = "Book Already Checked Out!!"
      end

      redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
    end

    def can_issue_more_books?
      max_books_allowed = Student.where(email: current_student.email).maximum(:max_book_allowed)
      checked_out_books_count = Checkout.checked_out_books_count(current_student.id)
      max_books_allowed > checked_out_books_count
    end

    def book_not_checked_out?(book)
      Checkout.find_by_student_and_book(current_student.id, book.id).nil?
    end

    def handle_book_hold_request
      if book_not_checked_out?(@book)
        HoldRequest.create_request(current_student.id, @book.id)
        flash[:notice] = "Book Hold Request Placed !!"
      else
        flash[:notice] = "Book Already Hold Request !!"
      end

      redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
    end

end
