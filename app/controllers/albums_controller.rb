class AlbumsController < InheritedResources::Base
  defaults resource_class: User::Album
  actions :all, except: [ :index ]

  #load_and_authorize_resource class: 'User::Album'

  def update_config
    resource.assets.find(params[:key]).insert_at(params[:position].to_i)
    render nothing: true
  end
end
