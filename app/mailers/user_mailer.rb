class UserMailer < ActionMailer::Base
  default from: "notifications@collisterator.com" #??
  
  def welcome_email(user)
    @user = user
    @url = https://collisterator.heroku.com
    mail(to: @user.email, subject: 'Welcome to Collisterator!')
  end

  def share_email(user, email, link)
    @user = user
    @email = email
    @link = link

    if @user.username
      mail(to: @email, subject: '#{@user.username} has shared a list with you.')
    else
      mail(to: @email, from: @user.email, subject: 'Check out this list I made!')
    end

  end


end
