class AddressesController < ApplicationController

  before_action :authenticate_admin!
  before_action :get_address
  before_action :set_address, only: [:show]


  def index
    @addresses = Address.all
  end

  def show; end

  private

  def set_address
      @address = Address.find(params[:id])
  end

  def get_address
    if params[:id]
      @address = Address.where(:university_id => params[:id])
    else
      @address = Address.all
    end
  end

  def address_params
    params.require(:address).permit(:street, :number, :complement, :neighbordhood,
                                            :city, :state, :country, :zipcode, :university_id, _destroy)
  end
end
