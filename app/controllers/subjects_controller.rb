class SubjectsController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /Subjects or /Subjects.json
  def index
    @subjects = Subject.ordered_by_name
  end

  # GET /Subjects/1 or /Subjects/1.json
  def show
  end

  # GET /Subjects/new
  def new
    @subject = Subject.new
  end

  # GET /Subjects/1/edit
  def edit
  end

  # POST /Subjects or /Subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subject_url(@subject), notice: "subject was successfully created." }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Subjects/1 or /Subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subject_url(@subject), notice: "subject was successfully updated." }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Subjects/1 or /Subjects/1.json
  def destroy
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_url, notice: "subject was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:name)
    end
end
