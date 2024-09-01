class TelephonesController < ApplicationController

  before_action :authenticate_admin!
  before_action :get_telephone
  before_action :set_telephone, only: [:show, :destroy]

  def index
    @telephones = Telephone.all
  end

  def show
  end

  def destroy
    @telephones.destroy

    respond_to do |format|
      format.html { redirect_to universities_path, notice: "Contact was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_telephone
      @telephones = Telephone.where(university_id: params[:id])
  end

  def get_telephone
    if params[:id]
      @telephones = Telephone.where(university_id: params[:id])
    else
      @telephones = Telephone.all
    end
  end

  def telephones_params
    params.require(:telephone).permit(:id, :phone, :contact, :email_contact, :university_id, :_destroy)
  end
  
end
