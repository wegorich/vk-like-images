module WithAssets
  extend ActiveSupport::Concern
  included do
    has_many :assets, order:'position ASC', as: :assetable
  end

  def asset_ids= ids
    ids = ids.split(',').keep_if{|i| i.to_i > 0} if ids.is_a? String
    super(ids)
  end
end
