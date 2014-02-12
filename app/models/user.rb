class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :username, :assets_attributes, :asset_ids

  attr_accessor :login

  has_many :authorizations,
           class_name: 'User::Authorization',
           dependent: :destroy
  has_many :albums,
           class_name: 'User::Album',
           dependent: :destroy
end
