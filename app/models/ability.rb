class Ability
  include CanCan::Ability

  def initialize(member)
    # Define abilities for the passed in user here. For example:
    #
    member ||= Member.new(role: 0) # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    if member.admin
      can :manage, :all

    else
      can [:read], Category do |model_name|
        model_name.read_level <= member.role
      end
      can :read, Article do |model_name|
        model_name.board.read_level <= member.role
      end
      can :create, Article do |model_name|
        model_name.board.write_level <= member.role
      end
      can [:update,:destroy], Article do |model_name|
        model_name.member == member
      end
      can [:update,:destroy], Comment do |model_name|
        model_name.member == member
      end
      can [:read], WikiPage do |model|
        member.role > 0
      end
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
