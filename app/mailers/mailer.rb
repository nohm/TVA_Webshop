class Mailer < ApplicationMailer
  # Method for sending account activation emails
  def send_account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation || Smart Parts"
  end

  # Method for sending password reset emails
  def send_password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset || Smart Parts"
  end

  # Method for sending a recommendation email
  def send_tell_a_friend(user, email, part)
    @user = user
    @part = Part.find(part)
    mail to: email, subject: "Tell A Friend Smart || Parts"
  end

  # Method for sending a reminder that a part is back in stock emails
  def send_part_reminder(user, part)
    @user = user
    @part = part
    mail to: user.email, subject: "A part is back in stock || Smart Parts"
  end

  # Method for sending a reminder that their order can be picked up emails
  def send_order_reminder(cart)
    @user = User.find(cart.user_id)
    @cart = cart
    mail to: @user.email, subject: "Your order (##{@cart.id}) is ready for pick up || Smart Parts"
  end
end
