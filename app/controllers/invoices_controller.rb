class InvoicesController < ApplicationController

	def show
		redirect_to root_path, :alert => "Unauthorized" and return unless (logged_in? && params[:user_id].to_i == current_user.id) || (logged_in? && current_user.manager?)
		@invoice = Invoice.find(params[:id])
		@cart = Cart.find(@invoice.cart_id)
		@cart_items = CartItem.where(cart_id: @invoice.cart_id)
		@colspan = @cart.coupon_code.blank? ? 2 : 3
		@user = User.find(params[:user_id])
		@country = ISO3166::Country[@user.country]


		weight_array = [0, 1000, 2000, 3000, 4000, 5000, 6000]
		shipping_array = [0.50, 1, 1.50, 2, 2.50, 3]
		@shipping_cost = 0
		@cart_amount_total = 0
		@cart_price_total = 0
		@cart_price_discount = 0
		@cart_items.each do |item|
			@cart_amount_total += item.amount
			@cart_price_total += (item.price_sale || item.price) * item.amount
			if !item.price_sale.blank?
				@cart_price_discount += ((item.price * item.amount) - (item.price_sale * item.amount))
			end

			if @cart.delivery_method == "Shipping"
				if item.part.weight.between?(weight_array[0], weight_array[1] - 1)
					@shipping_cost += item.amount * shipping_array[0]
				elsif item.part.weight.between?(weight_array[1], weight_array[2] - 1)
					@shipping_cost += item.amount * shipping_array[1]
				elsif item.part.weight.between?(weight_array[2], weight_array[3] - 1)
					@shipping_cost += item.amount * shipping_array[2]
				elsif item.part.weight.between?(weight_array[3], weight_array[4] - 1)
					@shipping_cost += item.amount * shipping_array[3]
				elsif item.part.weight.between?(weight_array[4], weight_array[5] - 1)
					@shipping_cost += item.amount * shipping_array[4]
				elsif item.part.weight.between?(weight_array[5], weight_array[6] - 1)
					@shipping_cost += item.amount * shipping_array[5]
				end
			end
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
