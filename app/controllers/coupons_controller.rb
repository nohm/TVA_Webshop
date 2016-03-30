class CouponsController < ApplicationController
	def index
		@coupons = Coupon.all.page(params[:page]).per(25).order('id ASC')
	end

	def new
		@coupon = Coupon.new
	end

	def create
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f unless params[:coupon][:price].blank?
		@coupon = Coupon.new(coupon_params)

		if @coupon.save
      redirect_to coupons_path
      flash[:success] = "Coupon added"
    else
      render 'new'
  	end
	end

	def edit
		@coupon = Coupon.find(params[:id])
	end

	def update
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f
		@coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      redirect_to coupons_path
      flash[:success] = "Coupon updated"
    else
      render 'edit'
    end
	end

	def destroy
		coupon = Coupon.find(params[:id])
		coupon.destroy
		redirect_to coupons_path
		flash[:success] = "Coupon deleted"
	end

	private

	def coupon_params
		params.require(:coupon).permit(:code, :category_id, :part_id, :user_id, :amount, :percent, :price)
	end
end
