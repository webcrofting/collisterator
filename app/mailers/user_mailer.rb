class UserMailer < ActionMailer::Base
  default from: "mailer@collisterator.com" 

  def welcome(user)
    mail(to: user.email, subject: 'Welcome to Collisterator!')
  end

  def shared_list_notification(item_share)
    @item = Item.find(item_share.item_id)
    @user_email = User.find(item_share.owner_id).email
    mail(to: item_share.shared_user_email, subject: "#{@user_email} has shared a list with you on Collisterator!") 
  end
end
