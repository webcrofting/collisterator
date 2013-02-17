class Ability
  include CanCan::Ability

  def initialize(user)
  
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
    elseif user.role? :payers
      can :manage, Item
      can [:read, :create], List_type
      # when ready: can edit and destroy their own lists, but not 
      # any others. 
      # can [:update, :destroy], List_type do |list_type|
      #   list_type.try(:owner) == user
      # end
    elseif user.role? :players
      can :manage, Item
      can :read, List_type
    else
      can :manage, Item
      can :read, List_type
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