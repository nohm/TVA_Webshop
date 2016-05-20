class SessionsController < ApplicationController
  def new
  end

  def create
    if User.find_by(email: params[:session][:login].downcase).blank?
      user = User.find_by(name: params[:session][:login])
    else
      user = User.find_by(email: params[:session][:login].downcase)
    end

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        if Cart.find_by(user_id: user.id, cart_status_id: search_status_id("In progress")).blank?
          Cart.create(user_id: user.id, delivery_method: "Shipping", purchased: false, cart_status_id: search_status_id("In progress"))
        end
        redirect_to root_path
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:notice] = message
        redirect_to root_path
      end

    else
      flash.now[:notice] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
