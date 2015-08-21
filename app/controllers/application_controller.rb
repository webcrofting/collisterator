class ApplicationController < ActionController::Base
  include Pundit # authorization gem

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private

  def user_not_authorized
    redirect_to(root_path)
    flash[:alert] = "You are not authorized to access this page."
  end
end
