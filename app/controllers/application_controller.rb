class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  rescue_from CanCan::AccessDenied, :with => :not_authorized

  def not_authorized
    if current_user
      flash[:notice] = 'Bad idea'
      redirect_to current_user
    else
      redirect_to new_user_session_url
    end
  end

end
