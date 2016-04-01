class CouponsController < ApplicationController
	def index
		
		@coupons = Coupon.all.page(params[:page]).per(25).order('id ASC')
	end

	def new
		@coupon = Coupon.new
	end

	def create
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f unless params[:coupon][:price].blank?
		params[:coupon][:category_ids] = params[:coupon][:category_ids].squish.split(" ").map(&:to_i)
		params[:coupon][:part_ids] = params[:coupon][:part_ids].squish.split(" ").map(&:to_i)
		params[:coupon][:user_ids] = params[:coupon][:user_ids].squish.split(" ").map(&:to_i)
		amount_days = params[:datetime][:days].to_i
    amount_hours = params[:datetime][:hours].to_i
    params[:coupon][:expiration_date] = Time.now.utc.to_date + amount_days.days + amount_hours.hours

		@coupon = Coupon.new(coupon_params)

		if @coupon.atleast_one_id(params[:coupon]) && @coupon.save
      redirect_to coupons_path
      flash[:success] = "Coupon added"
    else
      render 'new'
  	end
	end

	def edit
		@coupon = Coupon.find(params[:id])
		weekday_array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		@day = @coupon.expiration_date.day.to_s
		@weekday = weekday_array[@coupon.expiration_date.wday]
		@month = @coupon.expiration_date.month.to_s
		@year = @coupon.expiration_date.year.to_s
		@hour = @coupon.expiration_date.hour.to_s
	end

	def update
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f unless params[:coupon][:price].blank?
		params[:coupon][:category_ids] = params[:coupon][:category_ids].squish.split(" ").map(&:to_i)
		params[:coupon][:part_ids] = params[:coupon][:part_ids].squish.split(" ").map(&:to_i)
		params[:coupon][:user_ids] = params[:coupon][:user_ids].squish.split(" ").map(&:to_i)
		amount_days = params[:datetime][:days].to_i
    amount_hours = params[:datetime][:hours].to_i
    params[:coupon][:expiration_date] = Time.now.utc.to_date + amount_days.days + amount_hours.hours

		@coupon = Coupon.find(params[:id])
    if @coupon.atleast_one_id(params[:coupon]) && @coupon.update(coupon_params)
      redirect_to coupons_path
      flash[:success] = "Coupon updated"
    else
			weekday_array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
			@day = @coupon.expiration_date.day.to_s
			@weekday = weekday_array[@coupon.expiration_date.wday]
			@month = @coupon.expiration_date.month.to_s
			@year = @coupon.expiration_date.year.to_s
			@hour = @coupon.expiration_date.hour.to_s
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
		params.require(:coupon).permit(:code, :amount, :percent, :price, :expiration_date, :category_ids => [], :part_ids => [], :user_ids => [])
	end
end
