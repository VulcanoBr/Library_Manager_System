class UniversitiesController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_university, only: %i[ show edit update destroy ]

  # GET /universities or /universities.json
  def index
    @universities = University.with_address_and_telephones
  end

  # GET /universities/1 or /universities/1.json
  def show
    @address = Address.where(:university_id => params[:id])
    @telephones = Telephone.where(:university_id => params[:id])
  end

  # GET /universities/new
  def new
    @university = University.new
    @university.build_address
    @university.telephones.build
  end

  # GET /universities/1/edit
  def edit
  end

  # POST /universities or /universities.json
  def create
    @university = University.new(university_params)

    respond_to do |format|
      if @university.save
        format.html { redirect_to university_url(@university), notice: "University was successfully created." }
        format.json { render :show, status: :created, location: @university }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universities/1 or /universities/1.json
  def update
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to university_url(@university), notice: "University was successfully updated." }
        format.json { render :show, status: :ok, location: @university }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universities/1 or /universities/1.json
  def destroy
    @university.destroy

    respond_to do |format|
      format.html { redirect_to universities_url, notice: "University was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_university
      @university = University.find(params[:id])
    end

    def university_params
      params.require(:university).permit(:name, :email, :identification, :homepage, :checkout, :request, :bookmarks,
        address_attributes: [:id, :street, :number, :complement, :neighborhood, :city, :state, :country, :zipcode, :_destroy],
        telephones_attributes: [:id, :phone, :contact, :email_contact, :_destroy])
    end
end
