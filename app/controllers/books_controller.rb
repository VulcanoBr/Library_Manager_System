class BooksController < ApplicationController

  before_action :authenticate!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def authenticate!
    return authenticate_admin! if current_admin
    return authenticate_librarian! if current_librarian
    return authenticate_student! if current_student
  end

  # GET /books
  # GET /books.json
  def index
    @books = Book.ordered_by_title
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    if student_signed_in?
        redirect_to students_path, notice: 'Action not allowed.'
    else
      @book = Book.new
    end
  end

  # GET /books/1/edit
  def edit
    if student_signed_in?
        redirect_to students_path, notice: 'Action not allowed.'
    end
  end

  # POST /books
  # POST /books.json
  def create
    if student_signed_in?
        redirect_to students_path, notice: 'Action not allowed.'
    else
      @book = Book.new(book_params)

      respond_to do |format|
        if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
        else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
    else
      respond_to do |format|
        if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
        else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    if student_signed_in?
        redirect_to students_path, notice: 'Action not allowed.'
    else
      @book.destroy

      if current_admin.nil? and current_librarian.nil?
        respond_to do |format|
          format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
          format.json { head :no_content }
        end
      elsif !current_admin.nil?
        respond_to do |format|
          format.html { redirect_to show_books_admins_path, notice: 'Book was successfully destroyed.' }
          format.json { head :no_content }
        end
      elsif !current_librarian.nil?
        respond_to do |format|
          format.html { redirect_to librarian_book_view_path, notice: 'Book was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
    end
  end

  def search
    return redirect_to(show_books_url, notice: "Empty field!") if params[:search].blank?

    @results = Book.search_by_parameter(params[:search], params[:search_by])

    return redirect_to(show_books_url, notice: "No results found for your search #{params[:search_by]}.") if @results.empty?
  end


  def checkout_OLD # check if the given book is a special book or not
    @book = Book.find(params[:id])
    if @book.special_collection == true
      if Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first.nil?
        if SpecialBook.where(:student_id => current_student.id , :book_id => @book.id).first.nil?
          @specialbook_request =  SpecialBook.new(:student_id => current_student.id , :book_id => @book.id)
          @specialbook_request.save!
          flash[:notice] = "Book Hold Request Placed !!"
          return redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
        else
          flash[:notice] = "Book Hold Request Is Already Placed !!"
        end
      else
        flash[:notice] = "Book Already Checked Out !!!"
      end
    else
      if(@book.count>0)
        #@z = Student.select('education_level_id').where(:email => current_student.email)
        @z = Student.where(:email => current_student.email).max_book_allowed
        @t = Checkout.where(:student_id => current_student.id, :return_date => nil).count
        a=0
        if (@z == @t)
          flash[:notice] = "You cannot issue more books. Your request has been added to hold request list."
          redirect_to books_students_students_path
        else
          if Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first.nil?
            @checkout = Checkout.new(:student_id => current_student.id , :book_id => @book.id ,
                                    :issue_date => Date.today , :return_date =>nil ,
                                    :validity => Library.find(@book.library_id).borrow_limit)

            puts ("params #{params[:id]}")
            puts ("book count #{@book.count}")
            @book.decrement(:count)
            puts ("book count #{@book.count}")
            @user = current_student
            UserMailer.checkout_email(@user,@book).deliver_now
            @checkout.save!
            @book.save!
            flash[:notice] = "Book Successfully Checked Out"
            return redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
          else
            flash[:notice] = "Book Already Checked Out!!"
          end
        end
      else
        if Checkout.where(:student_id => current_student.id , :book_id => @book.id).first.nil?
          if HoldRequest.where(:student_id => current_student.id , :book_id => @book.id).first.nil?
            @hold_request =  HoldRequest.new(:student_id => current_student.id , :book_id => @book.id)
            @hold_request.save!
            flash[:notice] = "Book Hold Request Placed"
            return redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
          else
            flash[:notice] = "Book Hold Request Is Already Placed"
            return redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
          end
        else
          flash[:notice] = "Book Already Checked Out!!!"
          return redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
        end
      end
    end
    redirect_to books_students_students_path
  end

  def returnBook
    @book = Book.find(params[:id])
    if(@book.count>0)
      if !Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first.nil?
        @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first
        @checkout.update( :return_date => Date.today)
        @checkout.save!
        flash[:notice] = "Book Successfully returned !!!"
        @user = current_student
        UserMailer.returnbook_email(@user,@book).deliver_now
        @book.increment(:count)
        @book.save!
      else
        flash[:notice] = "Book is not checked out !!"
      end
    else
      if !Checkout.where(:student_id => current_student.id , :book_id => @book.id,:return_date => nil).nil?
        @hold_request = HoldRequest.where(:book_id => @book.id).first
        if @hold_request.nil?
          @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id , :return_date => nil)
          @checkout.update( :return_date => Date.today)
          flash[:notice] = "Book Successfully returned !!!"
          @user = current_student
          UserMailer.returnbook_email(@user,@book).deliver_now
          @book.increment(:count)
          @book.save!
        else
          @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id )
          @checkout.update( :return_date => Date.today)
          flash[:notice] = "Book Successfully returned !!!"
          @checkout_new = Checkout.new(:student_id => @hold_request.student_id , :book_id => @hold_request.book_id , :issue_date => Date.today , :return_date =>nil , :validity => Library.find(@book.library_id).borrow_limit)
          @checkout_new.save!
          UserMailer.checkout_email(User.find(@hold_request.student_id),@book).deliver_now
          @hold_request.destroy
        end
      end
    end
	  redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
  end

  def bookmark
    @book = Book.find(params[:id])
    @bookmark = Bookmark.where(:student_id => current_student.id , :book_id => @book.id).first
    if @bookmark.present?
      flash[:notice] = "Book is already bookmarked!!"
    else
      @bookmark = Bookmark.new(:student_id => current_student.id , :book_id => @book.id);
      @user = current_student
      UserMailer.bookmark_email(@user,@book).deliver_now
      @bookmark.save!
      flash[:notice] = "Book Added to your bookmarks"
    end

    if current_student.present?
      redirect_to books_students_path
    else
      redirect_to action: "index"
    end
    Transaction.
        find_or_initialize_by(:isbn => @book.isbn , :email => current_student.email).
        update!(:email => current_student.email,:bookmarks => true)

  end

  def unbookmark
    @book = Book.find(params[:id])
    @bookmark = Bookmark.by_student_and_book(current_student.id, @book.id).first
    if @bookmark
      @bookmark.destroy
      flash[:notice] = "Bookmark Removed successfully!!"
    else
      flash[:notice] = "Bookmark not found!!"
    end
    redirect_to action: "getBookmarkBooks"

  end


  def requestBook
    @book = Book.find(params[:id])
    @transaction = Transaction.requested_by_student(@book.isbn, current_student.email).first
    if @transaction.present?
      flash[:notice] = "Book is already Requested!!"
    else
      flash[:notice] = "Book Added to your Requested Lists"
    end
    Transaction.
        find_or_initialize_by(:isbn => @book.isbn , :email => current_student.email).
        update_attributes!(:email => current_student.email,:request => true)
    redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
  end

  def repealRequest
    @book = Book.find(params[:id])
    if @book.special_collection
      @special_book = SpecialBook.by_book_and_student(@book.id, current_student.id).first
      @special_book.destroy
    else
      @hold_request = HoldRequest.by_book(@book.id).first
      @hold_request.destroy
    end
    redirect_to getBookmarkBooks_students_path(student_id: current_student.id)
  end

  def approve_special_book
    @special_book_id = params[:id]
    @special_book  = SpecialBook.find(@special_book_id)

    @book  = Book.find(@special_book.book_id)
    @checkout = Checkout.new(:student_id => @special_book.student_id , :book_id => @special_book.book_id , :issue_date => Date.today , :return_date =>nil , :validity => Library.find(@book.library_id).borrow_limit)
    flash[:notice] = "Book Successfully Checked Out"
    @book.decrement(:count)
    @user = Student.find(@special_book.student_id)
    UserMailer.checkout_email(@user,@book).deliver_now
    @special_book = SpecialBook.find(@special_book_id)
    @special_book.destroy
    @checkout.save!
    @book.save!
    redirect_to librarian_special_book_librarians_path(library_id: current_librarian.library_id)
  end

  def reject_special_book
    @books = SpecialBook.find(params[:id])
    @books.destroy
    redirect_to librarian_special_book_librarians_path(library_id: current_librarian.library_id)
  end

  def viewBookHistory
    #@checkouts = Checkout.where.not(:return_date => nil ).where(:book_id => params[:id])
    @checkouts = Checkout.returned_books(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:isbn, :title, :published, :publication_date, :edition,
                      :cover, :summary, :special_collection, :count, :library_id, :subject_id,
                      :language_id, :publisher_id, :author_id)
    end
end
