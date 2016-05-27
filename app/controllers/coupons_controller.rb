class CouponsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@coupons = Coupon.all.page(params[:page]).per(10).order('id ASC')
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@coupon = Coupon.new
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		# Change comma's to dots
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f unless params[:coupon][:price].blank?
		# Squish the parameters and make them unique before saving them
		params[:coupon][:category_ids] = params[:coupon][:category_ids].squish.split(" ").map(&:to_i).uniq
		params[:coupon][:part_ids] = params[:coupon][:part_ids].squish.split(" ").map(&:to_i).uniq
		params[:coupon][:user_ids] = params[:coupon][:user_ids].squish.split(" ").map(&:to_i).uniq
		# Set the expiration date
		amount_days = params[:datetime][:days].to_i
    amount_hours = params[:datetime][:hours].to_i
    params[:coupon][:expiration_date] = Time.now.utc.to_date + amount_days.days + amount_hours.hours

		@coupon = Coupon.new(coupon_params)
		if @coupon.save
      redirect_to coupons_path
      flash[:success] = "Coupon added"
    else
      render 'new'
  	end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@coupon = Coupon.find(params[:id])
		# Give parameters to edit so it can use them
		weekday_array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		@day = @coupon.expiration_date.day.to_s
		@weekday = weekday_array[@coupon.expiration_date.wday]
		@month = @coupon.expiration_date.month.to_s
		@year = @coupon.expiration_date.year.to_s
		@hour = @coupon.expiration_date.hour.to_s
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		# Change comma's to dots
		params[:coupon][:price] = params[:coupon][:price].to_s.gsub(',', '.').to_f unless params[:coupon][:price].blank?
		# Squish the parameters and make them unique before saving them
		params[:coupon][:category_ids] = params[:coupon][:category_ids].squish.split(" ").map(&:to_i).uniq
		params[:coupon][:part_ids] = params[:coupon][:part_ids].squish.split(" ").map(&:to_i).uniq
		params[:coupon][:user_ids] = params[:coupon][:user_ids].squish.split(" ").map(&:to_i).uniq
		# Set the expiration date
		amount_days = params[:datetime][:days].to_i
    amount_hours = params[:datetime][:hours].to_i
    params[:coupon][:expiration_date] = Time.now.utc.to_date + amount_days.days + amount_hours.hours

		@coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      redirect_to coupons_path
      flash[:success] = "Coupon updated"
    else
    	# Give parameters to edit so it can use them
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
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		coupon = Coupon.find(params[:id])
		coupon.destroy
		redirect_to coupons_path
		flash[:success] = "Coupon deleted"
	end

	def coupon_category
		# Used in AJAX request to fill the category_select

		# If category_id isn't blank fill in #c_category_select and #p_category_select
		if !params[:device_id].blank?
	    id = params[:device_id]
		  @categories = Category.where(device_id: id).order('name ASC')
		  render :partial => 'coupon_category'
		else
			render :inline => 'Category failed'
		end
	end

	def coupon_part
		# Used in AJAX request to fill the part_select

		# If category_id isn't blank fill in #p_part_select
		if !params[:category_id].blank?
	    id = params[:category_id]
		  @parts = Part.where(category_id: id).order('name ASC')
		  render :partial => 'coupon_part'
		else
			render :inline => 'Part failed'
		end
	end

	private

	def coupon_params
		params.require(:coupon).permit(:code, :amount, :percent, :price, :expiration_date, :category_ids => [], :part_ids => [], :user_ids => [])
	end
end
