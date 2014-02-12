class AssetsController < InheritedResources::Base
  #respond_to :json
  layout false
  belongs_to :album, class_name: 'User::Album', polymorphic: true, optional: true

  def index
    if parent
      @assets = parent.assets
    else
      @assets = []
    end
    render json: {assets: @assets}
  end

  def create
    user = current_user
    @asset = Asset.new params[:asset]
    @asset.assetable = parent if parent
    @asset.user = user
    if @asset.save
      render template: 'assets/show.json.rabl'
    end
  end

end
