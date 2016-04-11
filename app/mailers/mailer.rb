class Mailer < ApplicationMailer
  def send_account_activation(user)
    @user = user
    mail to: user.email, subject: "Smart Parts Account activation"
  end

  def send_password_reset(user)
    @user = user
    mail to: user.email, subject: "Smart Parts password reset"
  end

  def send_tell_a_friend(user, email, part)
    @user = user
    @part = Part.find(part)
    mail to: email, subject: "Smart Parts Tell A Friend"
  end
end
