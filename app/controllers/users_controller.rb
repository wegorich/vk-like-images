class UsersController < InheritedResources::Base
  actions :all, except: [ :index, :create, :destroy ]

  protected
    def resource
      @user = current_user

      flash[:notice] = 'This page is not available' if params[:id] && current_user && current_user.id != params[:id].to_i
    end
end
