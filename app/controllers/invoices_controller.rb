class InvoicesController < ApplicationController

	def index
		@invoices = Invoice.all.page(params[:page]).per(25)
	end

	def show
		@invoice = Invoice.find(params[:id])
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
