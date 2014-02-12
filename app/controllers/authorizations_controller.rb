require 'authorization_builder'

class AuthorizationsController < ApplicationController
  respond_to :html, :js
  def create
    unless omniauth
      logger.debug "no omniauth"
      flash[:alert] = t(:provider_connection_failed)
      redirect_to root_path
    else
      if user_signed_in?
        add_authorization
      elsif try_sign_in_by_email
        sign_in_and_redirect(:user, @current_user)
      else
        if authorization_exists?
          sign_in_with_omniauth
        else
          sign_up_with_omniauth
        end
      end
    end
  end

  def auth_failure
    redirect_to '/users/sign_in', :alert => params[:message]
  end

  private

  def omniauth
    request.env["omniauth.auth"]
  end

  def add_authorization
    auth_builder = AuthorizationBuilder.new(omniauth, current_user)
    auth_builder.create_authorization
    redirect_to root_path
  end

  def authorization_exists?
    @authorization = User::Authorization.where(
        :provider => omniauth['provider'], :uid => omniauth['uid'].to_s
    ).first
  end

  def sign_in_with_omniauth
    flash[:notice] = t(:signed_in_successfully)
    if @authorization.user
      sign_in_and_redirect(:user, @authorization.user)
    else
      session[:omniauth_token] = @authorization.token
      redirect_to new_user_registration_url(with_provider: true)
    end
  end

  def sign_up_with_omniauth
    auth_builder = AuthorizationBuilder.new(omniauth)
    auth_builder.create_authorization
    session[:omniauth_token] = auth_builder.authorization.token
    redirect_to new_user_registration_url(with_provider: true)
  end

  def try_sign_in_by_email
    logger.debug "try_sign_in_by_email info: #{omniauth.info}"
    if omniauth.info.email && (try_user = User.find_by_email(omniauth.info.email)) && try_user.confirmed_at
      case omniauth['provider']
        when 'google_oauth2'
          @current_user = try_user if omniauth.extra.raw_info.verified_email
        when 'facebook'
          @current_user = try_user if omniauth.info.verified
      end
      if @current_user && (auth = authorization_exists?) && auth.user_id == nil
        auth.update_attribute :user_id, @current_user.id
      end
    end
    @current_user
  end
end