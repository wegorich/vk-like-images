object @asset if defined?(@asset)
attributes :id, :admin_user_id, :attachment_content_type, :assetable_type, :assetable_id, :attachment_file_name, :attachment_file_size, :attachment_updated_at

node :url do |asset|
  asset.url
end

node :thumb_url do |asset|
  asset.url(:thumb)
end