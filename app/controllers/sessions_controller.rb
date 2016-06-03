class SessionsController < ApplicationController
  def create
    # Checks if user can't be found with email
    if User.find_by(email: params[:session][:login].downcase).blank?
      # Find user by name
      user = User.find_by(name: params[:session][:login])
    else
      # Find user by email
      user = User.find_by(email: params[:session][:login].downcase)
    end

    # Check if user trying to log in is using the right password
    if user && user.authenticate(params[:session][:password])
      # Checks if the user is activated
      if user.activated?
        log_in user
        # Check if the user wants to remember his login, if so remember him otherwise forget him
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # Checks if the user has a cart, if not make one
        if Cart.find_by(user_id: user.id, cart_status_id: search_status_id("In progress")).blank?
          Cart.create(user_id: user.id, delivery_method: "Shipping", cart_status_id: search_status_id("In progress"))
        end
        redirect_to root_path
      # If user isn't activated give an error message
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:notice] = message
        redirect_to root_path
      end
    # If the password is incorrect give an error message
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
