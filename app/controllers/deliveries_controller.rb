class DeliveriesController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		cart = Cart.find(params[:cart])
		cart_item_ids = []
		cart.cart_items.each do |item|
			cart_item_ids << item.id
		end
		@deliveries = Delivery.where(cart_item_id: cart_item_ids).page(params[:page]).per(10)
		@cart_items = cart.cart_items
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@delivery = Delivery.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@delivery = Delivery.find(params[:id])

		if @delivery.update(delivery_params)
	    redirect_to request.referrer
	    flash[:success] = "Status updated"
	  else
	    redirect_to request.referrer
	    flash[:notice] = "Error while updating"
	  end
	end

	private

	def delivery_params
		params.require(:delivery).permit(:cart_item_id, :shipping_from_location, :shipping_to_location, :shipping_to_user, :cart_status_id)
	end
end
