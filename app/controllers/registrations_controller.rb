require 'authorization_builder'

class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def success
    respond_with(resource) do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  private
  def build_resource(*args)
    super
    if session[:omniauth_token] and params[:with_provider] == "true"
      AuthorizationBuilder.set_with_omniauth! session[:omniauth_token], @user
      @authorization = @user.authorizations.first
      @user.valid?
    end
  end

  protected
  def after_sign_up_path_for resource
    session[:just_signed_up] = true
    super(resource)
  end
end
