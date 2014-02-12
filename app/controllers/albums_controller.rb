class AlbumsController < InheritedResources::Base
  defaults resource_class: User::Album

  protected
  def resource
    @album = current_user.albums.find(params[:id])
  end
  def collection
    @albums = current_user.albums
  end
end
