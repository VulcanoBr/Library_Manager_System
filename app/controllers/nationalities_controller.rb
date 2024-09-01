class NationalitiesController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_nationality, only: %i[ show edit update destroy ]

  # GET /nationalities or /nationalities.json
  def index
    @nationalities = Nationality.ordered_by_name
  end

  # GET /nationalities/1 or /nationalities/1.json
  def show
  end

  # GET /nationalities/new
  def new
    @nationality = Nationality.new
  end

  # GET /nationalities/1/edit
  def edit
  end

  # POST /nationalities or /nationalities.json
  def create
    @nationality = Nationality.new(nationality_params)

    respond_to do |format|
      if @nationality.save
        format.html { redirect_to nationality_url(@nationality), notice: "Nationality was successfully created." }
        format.json { render :show, status: :created, location: @nationality }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nationality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nationalities/1 or /nationalities/1.json
  def update
    respond_to do |format|
      if @nationality.update(nationality_params)
        format.html { redirect_to nationality_url(@nationality), notice: "Nationality was successfully updated." }
        format.json { render :show, status: :ok, location: @nationality }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nationality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nationalities/1 or /nationalities/1.json
  def destroy
    @nationality.destroy

    respond_to do |format|
      format.html { redirect_to nationalities_url, notice: "Nationality was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_nationality
      @nationality = Nationality.find(params[:id])
    end

    def nationality_params
      params.require(:nationality).permit(:name)
    end
end
