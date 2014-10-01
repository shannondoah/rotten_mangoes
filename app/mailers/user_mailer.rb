class UserMailer < ActionMailer::Base
  default from: "notificationse@example.com"

  def goodbye_email(user)
    @user = user
    @url = 'http://example/com/login'
    mail(to: @user.email, subject: 'You are not welcome here anymore')
  end

end
