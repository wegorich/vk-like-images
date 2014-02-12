#require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  Secrets::secret['omniauth'].each do |service, definition|
    params = {}
    definition['scope'] and params[:scope] = definition['scope']  
    provider service.to_sym, definition['key'], definition['secret'], params
  end

  #if Secrets::secret['livejournal']
  #  _store = File::join(Rails.root, Secrets::secret['livejournal']['store'])
  #  provider :openid, :store => OpenID::Store::Filesystem.new(_store), :name => 'livejournal' 
  #end
end
