class User::Album < ActiveRecord::Base
  include WithAssets
  attr_accessible :name, :user_id
  belongs_to :user
end
