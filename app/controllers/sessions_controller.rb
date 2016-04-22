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
