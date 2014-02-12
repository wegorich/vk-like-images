class AlbumsController < InheritedResources::Base
  defaults resource_class: User::Album
end
