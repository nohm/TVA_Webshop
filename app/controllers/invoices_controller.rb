class InvoicesController < ApplicationController

	def show
		redirect_to root_path, :alert => "Unauthorized" and return unless (logged_in? && params[:user_id].to_i == current_user.id) || (logged_in? && current_user.manager?)
		@invoice = Invoice.find(params[:id])
		@cart = Cart.find(@invoice.cart_id)
		@cart_items = CartItem.where(cart_id: @invoice.cart_id)
		@user = User.find(params[:user_id])
		@country = ISO3166::Country[@user.country]
		if @cart.delivery_method == "Pick up"
			@location = Location.find(@cart.location_id)
		end


		@cart_amount_total = 0
		@cart_price_total = 0
		@cart_price_discount = 0
		@cart_price_total_discount = 0
		@cart_items.each do |item|
			@cart_amount_total += item.amount
			@cart_price_total += item.price_tier_discount * item.amount #(item.price_coupon_discount || item.price) * item.amount
			if !item.price_coupon_discount.blank?
				@cart_price_discount += ((item.price_tier_discount * item.amount) - (item.price_coupon_discount * item.amount))
			end
		end

		if @cart_price_discount != 0
			@cart_price_total_discount = @cart_price_total - @cart_price_discount
		end
	end

	def destroy
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.admin?
		invoice = Invoice.find(params[:id])
    invoice.destroy
    redirect_to :back
    flash[:success] = "Invoice deleted"
	end

	def create
		@invoice = Invoice.new(invoice_params)
	end

	private

	def invoice_params
		params.require(:invoice).permit(:user_id)
	end
end
