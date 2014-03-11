class UserProfilePresenter

  def initialize(user)
    @user = user
  end

  def user_templates 
    @list_types ||= ListType.where("user_id" => @user.id)
  end

  def user_lists
    @user_lists ||= @user.root_items
  end

  def shared_lists
    @shared_lists ||= @user.shared_items
  end
end
