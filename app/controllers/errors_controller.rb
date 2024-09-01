class ErrorsController < ApplicationController

  def not_found
    render_error_page(404)
  end

  def unprocessable_entity
    render_error_page(422)
  end

  def internal_server_error
    render_error_page(500)
  end

  def handle_routing_error
    render error_page(404)
  end

  private

  def render_error_page(status)
    render template: "errors/#{status}", status: status, layout: 'error'
  end
end
