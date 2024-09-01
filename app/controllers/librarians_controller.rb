class LibrariansController < ApplicationController
  #include Accessible
  before_action :authenticate!
  before_action :set_librarian, only: [:show, :edit, :update, :destroy]

  def authenticate!
    return authenticate_admin! if current_admin
    authenticate_librarian!
  end


  # GET /librarians
  # GET /librarians.json
  def index
    if admin_signed_in?
      @librarians = Librarian.all
	  elsif student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    else
      @lib = Librarian.find_by(:email => current_librarian.email)
      if @lib.approved == 'No'
      redirect_to restricted_path
      else
        library_name = current_librarian.library
        @library = Library.all.where(:name => library_name).first
        @librarians = Librarian.all
      end
    end
  end

  def restricted
    if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end
  end

  def home_page
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end

  end

  # GET /librarians/1
  # GET /librarians/1.json
  def show
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end
  end

  # GET /librarians/new
  def new
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    else
		if !current_librarian.nil?
			@lib = Librarian.find_by(:email => current_librarian.email)
			  if @lib.approved == 'No'
				redirect_to restricted_path
			  else
				@librarian = Librarian.new
			  end
		else
			@librarian = Librarian.new
		end
	 end
  end

  # GET /librarians/1/edit
  def edit
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end
  end

  # POST /librarians
  # POST /librarians.json
  def create
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    else
		@librarian = Librarian.new(librarian_params)

		respond_to do |format|
		  if @librarian.save
			format.html { redirect_to @librarian, notice: 'Librarian was successfully created.' }
			format.json { render :show, status: :created, location: @librarian }
		  else
			format.html { render :new }
			format.json { render json: @librarian.errors, status: :unprocessable_entity }
		  end
		end
	end
  end

  # PATCH/PUT /librarians/1
  # PATCH/PUT /librarians/1.json
  def update

      respond_to do |format|
        if @librarian.update(librarian_params)
          format.html { redirect_to @librarian, notice: 'Librarian was successfully updated.' }
          format.json { render :show, status: :ok, location: @librarian }
        else
          format.html { render :edit }
          format.json { render json: @librarian.errors, status: :unprocessable_entity }
        end
      end

  end

  # DELETE /librarians/1
  # DELETE /librarians/1.json
  def destroy
    if student_signed_in?
        sign_out :librarian
        redirect_to students_path, notice: 'Action not allowed.'
    else
      @librarian.destroy
      if current_admin.nil?
          respond_to do |format|
            format.html { redirect_to librarians_path, notice: 'Librarian was successfully destroyed.' }
            format.json { head :no_content }
          end
      else
        respond_to do |format|
          format.html { redirect_to show_librarians_admins_path, notice: 'Librarian was successfully removed.' }
          format.json { head :no_content }
        end
      end
    end
  end

  def search_book
    return redirect_to(search_book_librarians_url, notice: "Empty field!") if params[:search].blank?

    @results = Book.search_by_parameter_librarian(params[:search], params[:search_by], params[:library_id])

    return redirect_to(search_book_librarians_url, notice: "No results found for your search #{params[:search_by]}.") if @results.nil?
  end

  def list_checkedoutBooksAndStudents
    @results = Checkout.checkedout_books_and_students(params[:library_id])
  end

  def getOverdueBooks
    @checkouts = Checkout.overdue_books(params[:library_id])
    if @checkouts.present?
      @fines = Array.new
      @checkouts.each do |checkout|
        if checkout.issue_date + checkout.validity < Date.today
          delay = (Date.today - checkout.issue_date).to_i - checkout.validity
          fine_per_day  = Library.overdue_fines
          @fines.push({:fine_ammount => delay * fine_per_day, :book_id => checkout.book_id , :student_id => checkout.student_id})
        else
          @fines.push({:fine_ammount => 0, :book_id => checkout.book_id ,:student_id => checkout.student_id})
        end
      end
    end
  end

  def list_checkedoutBooks
    @books = Book.checked_out(params[:library_id])
  end

  def viewHoldRequest
    @request = HoldRequest.for_library(params[:library_id])
  end

  def librarian_special_book
    @special_books = SpecialBook.for_library(params[:library_id])
  end

  def librarian_book_view
    @books = Book.from_library(params[:library_id])
  end

  def viewBookHistory
    @checkouts = Checkout.returned_books(params[:id])
  end

  def approve_special_book
    @special_book_id = params[:id]
    @special_book  = SpecialBook.find(@special_book_id)
    @book  = Book.find(@special_book.book_id)
    @checkout = Checkout.new(:student_id => @special_book.student_id , :book_id => @special_book.book_id , :issue_date => Date.today , :return_date =>nil , :validity => Library.find(@book.library_id).borrow_limit)
    @book.decrement(:count)
    @user = Student.find(@special_book.student_id)
    UserMailer.checkout_email(@user,@book).deliver_now
    @special_book.destroy
    @checkout.save!
    @book.save!
    flash[:notice] = "Book Successfully Checked Out"
    redirect_to librarian_special_book_librarians_path(library_id: current_librarian.library_id)
  end

  def reject_special_book
    @books = SpecialBook.find(params[:id])
    @books.destroy
    flash[:notice] = "Special Book rejected !!!!"
    redirect_to librarian_special_book_librarians_path(library_id: current_librarian.library_id)
  end



  private
    def set_librarian
      @librarian = Librarian.find(params[:id])
    end

    def librarian_params
      params.require(:librarian).permit(:name, :email, :identification, :password,  :phone, :approved, :library_id)
    end
end
