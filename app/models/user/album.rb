class User::Album < ActiveRecord::Base
  include WithAssets
  attr_accessible :name, :user_id, :assets_attributes, :asset_ids
  belongs_to :user
end
