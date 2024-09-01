class AdminsController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins
  # POST /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        bypass_sign_in(@admin)
        format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_book
    return redirect_to(search_book_admins_path, notice: "Empty field!") if params[:search].blank?

    @results = Book.search_by_parameter_admin(params[:search], params[:search_by])

    return redirect_to(search_book_admins_path, notice: "No results found for your search #{params[:search_by]}.") if @results.nil?
  end

  def show_librarians
    @librarians = Librarian.ordered_by_name
  end

  def show_students
    @students = Student.ordered_by_name
  end

  def show_books
    @books = Book.ordered_by_title
  end

  def show_libraries
    @libraries = Library.ordered_by_name
  end

  def viewBookHistory
    @checkouts = Checkout.returned_books(params[:id])
  end

  def list_checkedoutBooksAndStudents
    @results = Checkout.checkedout_books_and_students_admin
  end

  def getOverdueBooks
    @checkouts = Checkout.overdue

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
    @books = Book.checked_out_admin

  end

  def viewHoldRequest
    @request = HoldRequest.all
  end

  private
    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      params.require(:admin).permit(:name, :identification, :email, :password)
    end

end
