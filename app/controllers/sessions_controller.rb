require 'authorization_builder'

class SessionsController < Devise::SessionsController
  respond_to :html, :js
end
