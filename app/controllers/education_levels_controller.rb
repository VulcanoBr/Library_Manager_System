class EducationLevelsController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_education_level, only: %i[ show edit update destroy ]

  # GET /education_levels or /education_levels.json
  def index
    @education_levels = EducationLevel.ordered_by_name
  end

  # GET /education_levels/1 or /education_levels/1.json
  def show
  end

  # GET /education_levels/new
  def new
    @education_level = EducationLevel.new
  end

  # GET /education_levels/1/edit
  def edit
  end

  # POST /education_levels or /education_levels.json
  def create
    @education_level = EducationLevel.new(education_level_params)

    respond_to do |format|
      if @education_level.save
        format.html { redirect_to education_level_url(@education_level), notice: "Education level was successfully created." }
        format.json { render :show, status: :created, location: @education_level }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @education_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /education_levels/1 or /education_levels/1.json
  def update
    respond_to do |format|
      if @education_level.update(education_level_params)
        format.html { redirect_to education_level_url(@education_level), notice: "Education level was successfully updated." }
        format.json { render :show, status: :ok, location: @education_level }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @education_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /education_levels/1 or /education_levels/1.json
  def destroy
    @education_level.destroy

    respond_to do |format|
      format.html { redirect_to education_levels_url, notice: "Education level was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_education_level
      @education_level = EducationLevel.find(params[:id])
    end

    def education_level_params
      params.require(:education_level).permit(:name)
    end
end
