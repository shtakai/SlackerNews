class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

      can :update, Category do |category|
        category.user == user
      end

      can [:update, :destroy], Comment do |comment|
        comment.user == user
      end

      can :update, Post do |post|
        post.user == user
      end

      # only allow update and edit, admin functions are in other action
      can [:update, :edit], User do |u|
        u == user
      end

      # admin is within the role enum, if you ever wonder (thanks simple_enum)
      if user.admin?
        can :manage, :all
      end

      # darf jetzt erstmal alles außer User bearbeiten
      if user.mod?
        can [:update, :destroy], Post
        can [:update, :destroy], Comment
        can [:update, :destroy], Category
      end
  end
end
