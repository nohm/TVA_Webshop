class PartStocksController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_stocks = PartStock.where(part_id: params[:part_id]).page(params[:page]).per(10).order('id ASC')
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_stock = PartStock.new
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_stock = PartStock.new(part_stock_params)
		if @part_stock.save
      redirect_to device_product_category_part_part_stocks_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Stock added"
    else
      render 'new'
  	end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_stock = PartStock.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_stock = PartStock.find(params[:id])

		if PartStock.where(part_id: @part_stock.part_id).sum('stock') == 0 && params[:part_stock][:stock].to_i > 0
      reminders = Reminder.where(part_id: @part_stock.part_id)
      reminders.each do |reminder|
        if reminder.updated_at > 2.weeks.ago
          user = User.find(reminder.user_id)
          Mailer.send_part_reminder(user, @part_stock.part).deliver_now
        end
        reminder.destroy
      end
    end

    if @part_stock.update(part_stock_params)
      redirect_to device_product_category_part_part_stocks_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Stock updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		part_stock = PartStock.find(params[:id])
		part_stock.destroy
		redirect_to device_product_category_part_part_stocks_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
		flash[:success] = "Stock deleted"
	end

	def options_sublocation
	  id = params[:id]

 	  unless id.blank?
 	  	@sublocations = Sublocation.where(location_id: id).order('name ASC')
	    render :partial => 'options_sublocation'
		end
	end

	private

	def part_stock_params
		params.require(:part_stock).permit(:part_id, :location_id, :stock, :sublocation_id)
	end
end
