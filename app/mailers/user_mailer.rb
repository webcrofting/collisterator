class UserMailer < ActionMailer::Base
  default from: "mecharaptors@gmail.com"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Collisterator!')
  end

  def shared_list_notification(user, email, item_token)
    @item_token
    mail(to: @email, subject: "#{user.email} has shared a list with you on Collisterator!")
  end

  def test(user)
    @user = user
    @
    @recipients = "annasazi@gmail.com"
    @subject = "Hey so some guy named #{user.email} signed up for collisterator"
    mail(to: @recipients, subject: @subject)
  end


end
