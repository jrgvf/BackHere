class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.is_admin?
        can :access, :rails_admin
        can :manage, :all
      elsif user.is_seller?
        apply_seller_permissions(user) unless user.account.blocked?
      end
    end
  end

  private

  def apply_seller_permissions seller
    seller.account.permissions.each do |permission|
      if permission.model_exists?
        can permission.action.to_sym, permission.subject.constantize
      else
        can permission.action.to_sym, permission.subject.to_sym
      end
    end
  end

end

## Exemplo de utilização em um controller
# authorize! :manage, :BetaTestt, message: "Você não tem autorização para executar essa ação."

# Define abilities for the passed in user here. For example:
#
#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
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
