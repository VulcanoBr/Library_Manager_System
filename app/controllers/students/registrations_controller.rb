# frozen_string_literal: true

class Students::RegistrationsController < Devise::RegistrationsController

   before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  def new
    @student = Student.new
  end

  private

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :phone, :password, :education_level_id, :university_id, :max_book_allowed])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    '/students'
  end

end
