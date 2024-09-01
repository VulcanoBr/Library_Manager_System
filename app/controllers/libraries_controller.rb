class LibrariesController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_library, only: [:show, :edit, :update, :destroy]

  # GET /libraries
  # GET /libraries.json
  def index
    @libraries = Library.ordered_by_name
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
  end

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library.destroy
	if current_admin.nil?
		respond_to do |format|
		  format.html { redirect_to libraries_path, notice: 'Library was successfully destroyed.' }
		  format.json { head :no_content }
		end
	else
		respond_to do |format|
		  format.html { redirect_to libraries_path, notice: 'Library was successfully removed.' }
		  format.json { head :no_content }
		end
	end
  end

  private
    def set_library
      @library = Library.find(params[:id])
    end

    def library_params
      params.require(:library).permit(:name, :email, :location, :borrow_limit, :overdue_fines, :university_id)
    end
end
