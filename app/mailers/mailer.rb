class Mailer < ApplicationMailer
  def send_account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation || Smart Parts"
  end

  def send_password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset || Smart Parts"
  end

  def send_tell_a_friend(user, email, part)
    @user = user
    @part = Part.find(part)
    mail to: email, subject: "Tell A Friend Smart || Parts"
  end

  def send_part_reminder(user, part)
    @user = user
    @part = part
    mail to: user.email, subject: "A part is back in stock || Smart Parts"
  end
end
