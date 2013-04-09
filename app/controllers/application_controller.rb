class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_ability
    @current_ability ||= Ability.new(current_player)
  end

  def not_found
    raise ActionController::RoutingError.new("Not found")
  end

  rescue_from CanCan::AccessDenied do |exc|
    redirect_to :root, alert: exc.message
  end
end
