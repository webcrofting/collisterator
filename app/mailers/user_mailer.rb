class UserMailer < ActionMailer::Base
  #have to set up a notifications@collisterator or the like first
  #default from: "notifications@collisterator.com" #??
  default from: "mecharaptors@gmail.com"

  def welcome_email(user)
    @user = user
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

  def test(user)
    logger.debug "No seriously. anything here would be nice."
    @recipients = "annasazi@gmail.com"
    @subject = "Hey so some guy named #{user.email} signed up for collisterator"
    @body = "You should probably go celebrate or something."
  end


end
