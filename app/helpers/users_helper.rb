module UsersHelper
  def reg_resource_name
    :user
  end

  def reg_resource
    @reg_resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def social_icon(provider, type = nil)
    type = type ? "-#{type}" : ''
    content_tag(:i, nil, class: "icon-#{provider.to_s+ type}")
  end
end
