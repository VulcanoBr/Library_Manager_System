# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController

   before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  def new
    @admin = Admin.new
  end

  private

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
   end

  # The path used after sign up.
   def after_sign_up_path_for(resource)
     '/admins'
   end

end
