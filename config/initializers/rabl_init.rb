Rabl.configure do |config|
  #config.cache_all_output = true
  config.cache_sources = Rails.env != 'development' # Defaults to false
  config.view_paths = [Rails.root.join('app/views')]
  config.include_child_root = false
end
