#class AuthorizationBuilder
#  attr_reader :omnihash, :user, :authorization
#  attr_accessor :auth_attribures
#
#  def initialize omnihash, user = nil
#    @omnihash = omnihash
#    @user     = user
#    @auth_attribures = {}
#    @authorization = {}
#    omniauth_unfold
#  end
#
#  def create_authorization
#    @authorization = User::Authorization.create auth_attribures
#  end
#
#  def self.set_with_omniauth! omniauth_token, user
#    authorization = User::Authorization.find_by_token(omniauth_token)
#
#    if authorization
#      user.authorizations << authorization
#
#      user.email    = authorization.email if user.email.blank?
#      user.username = authorization.username if user.username.blank?
#
#      user.build_profile do |profile|
#        profile.fio         = authorization.fio
#        profile.first_name  = authorization.first_name
#        profile.last_name   = authorization.last_name
#        profile.middle_name = authorization.middle_name
#        profile.birth_date  = authorization.birth_date
#        profile.gender      = authorization.gender
#      end
#    end
#  end
#
#private
#
#  def omniauth_unfold
#    auth_attribures[:uid]       = omnihash['uid']
#    auth_attribures[:provider]  = omnihash['provider']
#    auth_attribures[:data]      = get_extra_data
#
#    get_omniauth_credentials
#
#    auth_attribures[:primary]   = true
#    connect_to_user if user.present?
#  end
#
#  def get_extra_data
#    data = omnihash['info'].merge(omnihash['extra']['raw_info']).delete_if do |key, value|
#      value.is_a?(Hashie::Mash) or value.is_a?(Array)
#    end
#    data[:username] = data[:nickname]
#    data
#  end
#
#  def get_omniauth_credentials
#    if omnihash['credentials'].present?
#      auth_attribures[:token]   = omnihash['credentials']['token']
#      auth_attribures[:secret]  = omnihash['credentials']['secret']
#    end
#  end
#
#  def connect_to_user
#    auth_attribures[:primary] = false if user.authorizations.blank?
#    auth_attribures[:user_id] = user.id
#  end
#end
