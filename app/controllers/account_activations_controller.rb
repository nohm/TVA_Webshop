class AccountActivationsController < ApplicationController
	def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      Cart.create(user_id: user.id, delivery_method: "Shipping", purchased: false, cart_status_id: search_status_id("In progress"))
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
