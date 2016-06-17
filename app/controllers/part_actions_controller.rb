class PartActionsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_actions = PartAction.all.page(params[:page]).per(10)
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_action = PartAction.new()
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @part_action = PartAction.new(part_action_params)
	  if @part_action.save
	    redirect_to actions_path
	    flash[:success] = "Action created"
	  else
	    render 'new'
	  end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_action = PartAction.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @part_action = PartAction.find(params[:id])
    if @part_action.update(part_action_params)
      redirect_to actions_path
      flash[:success] = "Action updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    part_action = PartAction.find(params[:id])
    carts = Cart.where(cart_status_id: search_status_id("In progress"))
		cart_items = CartItem.where(cart_id: carts.ids, part_id: part_action.part_id)
		cart_items.each do |item|
			item.price_sale = nil
			item.save
		end
    part_action.destroy
    redirect_to request.referrer
    flash[:success] = "Action deleted"
	end

	private

	def part_action_params
		params.require(:part_action).permit(:part_id, :price)
	end
end
