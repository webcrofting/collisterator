class UserMailer < ActionMailer::Base
  default from: "mecharaptors@gmail.com"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Collisterator!')
  end

  def shared_list_notification(item_share)
    @item = Item.find(item_share.item_id)
    @user_email = User.find(item_share.owner_id).email
    mail(to: item_share.shared_user_email, subject: "#{@user_email} has shared a list with you on Collisterator!")
  end

  def test(user)
    @user = user
    @recipients = "annasazi@gmail.com"
    @subject = "Hey so some guy named #{user.email} signed up for collisterator"
    mail(to: @recipients, subject: @subject)
  end


end
