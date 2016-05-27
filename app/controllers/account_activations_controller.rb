class AccountActivationsController < ApplicationController
  def edit
    # Gets user by email
    user = User.find_by(email: params[:email])
    # Checks if user is valid, not activated and the activation hash is the same as in the URL. If so activate the account
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      Cart.create(user_id: user.id, delivery_method: "Shipping", purchased: false, cart_status_id: search_status_id("In progress"))
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      flash[:notice] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
