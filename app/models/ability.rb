class Ability
  include CanCan::Ability

  def initialize(user)
  
    user ||= User.new # guest user (not logged in)
    if user.role? :paying
      # this will eventually change:
      can :manage, :all
      # we don't want even the paying kind to delete/update list_types
      # can [:read, :create, :update, :destroy], Item
      # can [:read, :derive, :edit_derived], ListType
      # 2 of the above methods do not exist yet. New controller actions?
    elseif user.role? :freeloader
      can [:read, :create, :update, :destroy], Item
    else
      can :read, :all
    end
    
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
