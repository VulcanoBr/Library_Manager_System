# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController

  before_action :configure_sign_in_params, only: [:create]

  private

  def after_sign_in_path_for(resource)
    '/admins'
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
