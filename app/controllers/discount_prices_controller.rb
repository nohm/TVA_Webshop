class DiscountPricesController < ApplicationController
	def index
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@discount_prices = DiscountPrice.where(part_id: params[:part_id])
	end

	def new
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@discount_price = DiscountPrice.new
	end

	def create
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		params[:discount_price][:price] = params[:discount_price][:price].to_s.gsub(',', '.').to_f
		@discount_price = DiscountPrice.new(discount_price_params)
    if @discount_price.save
      redirect_to device_product_category_part_discount_prices_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Price added"
    else
      render 'new'
    end
	end

	def edit
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@discount_price = DiscountPrice.find(params[:id])
	end

	def update
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		params[:discount_price][:price] = params[:discount_price][:price].to_s.gsub(',', '.').to_f
		@discount_price = DiscountPrice.find(params[:id])
    if @discount_price.update(discount_price_params)
      redirect_to device_product_category_part_discount_prices_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Price updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		discount_price = DiscountPrice.find(params[:id])
		discount_price.destroy
		redirect_to device_product_category_part_discount_prices_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	end

	private

	def discount_price_params
    params.require(:discount_price).permit(:part_id, :amount, :price)
  end
end
