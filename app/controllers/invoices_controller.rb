class InvoicesController < ApplicationController

	def show
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && params[:user_id].to_i == current_user.id || logged_in? && current_user.manager?
		@invoice = Invoice.find(params[:id])
		@carts = Cart.find(@invoice.cart_ids)
		@user = User.find(params[:user_id])
		@country = ISO3166::Country[@user.country]


		weight_array = [0, 999, 1000, 1999, 2000, 2999, 3000, 3999, 4000, 4999, 5000, 5999]
		shipping_array = [0.50, 1, 1.50, 2, 2.50, 3]
		@shipping_cost = 0
		@cart_amount_total = 0
		@cart_price_total = 0
		@carts.each do |cart|
			@cart_amount_total += cart.amount
			@cart_price_total += (cart.part.price_ex * cart.amount)

			if cart.part.weight.between?(weight_array[0], weight_array[1])
				@shipping_cost += cart.amount * shipping_array[0]
			elsif cart.part.weight.between?(weight_array[2], weight_array[3])
				@shipping_cost += cart.amount * shipping_array[1]
			elsif cart.part.weight.between?(weight_array[4], weight_array[5])
				@shipping_cost += cart.amount * shipping_array[2]
			elsif cart.part.weight.between?(weight_array[6], weight_array[7])
				@shipping_cost += cart.amount * shipping_array[3]
			elsif cart.part.weight.between?(weight_array[8], weight_array[9])
				@shipping_cost += cart.amount * shipping_array[4]
			elsif cart.part.weight.between?(weight_array[10], weight_array[11])
				@shipping_cost += cart.amount * shipping_array[5]
			end
		end
	end

	def destroy
		invoice = Invoice.find(params[:id])
    invoice.destroy
    redirect_to invoices_path
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
