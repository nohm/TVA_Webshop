class DeliveriesController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@cart = Cart.find(params[:cart])
		@cart_items = @cart.cart_items
		@deliveries = Delivery.where(cart_item_id: @cart_items.ids).order("id").page(params[:page]).per(10)
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@delivery = Delivery.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@delivery = Delivery.find(params[:id])
		@cart = @delivery.cart_item.cart
		@deliveries = Delivery.where(cart_item_id: @cart.cart_items.ids)

		if @delivery.update(delivery_params)
			# Check if all the deliveries are the same status
	  	if @deliveries.select(:cart_status_id).distinct.length == 1
	  		# Check if the cart_status_id params are the same as the "Waiting for pick up" status
	  		if params[:delivery][:cart_status_id].to_i == search_status_id("Waiting for pick up")
	  			Mailer.send_order_reminder(@cart).deliver_now
	  		end
	  		# Update the status of the cart
	  		@cart.update_attributes(cart_status_id: params[:delivery][:cart_status_id])
	  		redirect_to cart_status_deliveries_path(params[:delivery][:cart_status_id], cart: @cart.id), :flash => { :success => "Status updated" } and return
			end
	    redirect_to request.referrer
	    flash[:success] = "Status updated"
	  else
	    redirect_to request.referrer
	    flash[:notice] = "Error while updating"
	  end
	end

	private

	def delivery_params
		params.require(:delivery).permit(:cart_status_id)
	end
end
