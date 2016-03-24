class InvoicesController < ApplicationController

	def show
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && params[:user_id].to_i == current_user.id || logged_in? && current_user.manager?
		@invoice = Invoice.find(params[:id])
		@carts = Cart.find(@invoice.cart_ids)
		@user = User.find(params[:user_id])
		@country = ISO3166::Country[@user.country]

		@cart_amount_total = 0
		@cart_price_total = 0
		@carts.each do |cart|
			@cart_amount_total += cart.amount
			@cart_price_total += (cart.part.price_ex * cart.amount)
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
