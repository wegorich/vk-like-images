class Ability
  include CanCan::Ability

  def initialize(user, site)
    user ||= User.new

    can :all, User::Album do |album|
      album.try(:user) == user
    end
  end
end
