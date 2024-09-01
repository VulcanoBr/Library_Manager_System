class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  rescue_from StandardError, with: :handle_internal_server_error

  rescue_from ActionController::RoutingError, with: :handle_routing_error

  private

  def handle_routing_error
    render_error_page(404)
  end

  def handle_not_found(exception)
    render_error_page(404)
  end

  def handle_internal_server_error(exception)
    render_error_page(500)
  end

  def render_error_page(status)
    render template: "errors/#{status}", status: status, layout: 'error'
  end

end
