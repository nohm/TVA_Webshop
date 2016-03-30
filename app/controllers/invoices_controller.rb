class InvoicesController < ApplicationController

	def show
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && params[:user_id].to_i == current_user.id || logged_in? && current_user.manager?
		@invoice = Invoice.find(params[:id])
		@cart_items = CartItem.where(cart_id: @invoice.cart_id)
		@user = User.find(params[:user_id])
		@country = ISO3166::Country[@user.country]


		weight_array = [0, 999, 1000, 1999, 2000, 2999, 3000, 3999, 4000, 4999, 5000, 5999]
		shipping_array = [0.50, 1, 1.50, 2, 2.50, 3]
		@shipping_cost = 0
		@cart_amount_total = 0
		@cart_price_total = 0
		@cart_items.each do |item|
			@cart_amount_total += item.amount
			@cart_price_total += (item.part.price_ex * item.amount)

			if item.part.weight.between?(weight_array[0], weight_array[1])
				@shipping_cost += item.amount * shipping_array[0]
			elsif item.part.weight.between?(weight_array[2], weight_array[3])
				@shipping_cost += item.amount * shipping_array[1]
			elsif item.part.weight.between?(weight_array[4], weight_array[5])
				@shipping_cost += item.amount * shipping_array[2]
			elsif item.part.weight.between?(weight_array[6], weight_array[7])
				@shipping_cost += item.amount * shipping_array[3]
			elsif item.part.weight.between?(weight_array[8], weight_array[9])
				@shipping_cost += item.amount * shipping_array[4]
			elsif item.part.weight.between?(weight_array[10], weight_array[11])
				@shipping_cost += item.amount * shipping_array[5]
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
