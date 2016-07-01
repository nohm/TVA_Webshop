class PartActionsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_actions = PartAction.all.order('id ASC').page(params[:page]).per(10)
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_action = PartAction.new()
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:part_action][:price] = params[:part_action][:price].to_s.gsub(',', '.').to_f
    @part_action = PartAction.new(part_action_params)
	  if @part_action.save
	  	carts = Cart.where(cart_status_id: search_status_id("In progress"))
			cart_items = CartItem.where(cart_id: carts.ids, part_id: @part_action.part_id)
			cart_items.each do |item|
				item.price_sale = @part_action.price
				item.save
			end
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
    params[:part_action][:price] = params[:part_action][:price].to_s.gsub(',', '.').to_f
    if @part_action.update(part_action_params)
      carts = Cart.where(cart_status_id: search_status_id("In progress"))
			cart_items = CartItem.where(cart_id: carts.ids, part_id: @part_action.part_id)
			cart_items.each do |item|
				item.price_sale = @part_action.price
				item.save
			end
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

	# Method for updating PartAction.active
	def show_on_homepage
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		part_action = PartAction.find(params[:part_action_id])
		if part_action.active == false
			# Checks if there is any other action already active, if so set active to false
			if PartAction.where(active: true).any?
				old_part_action = PartAction.where(active: true).first
				old_part_action.update_attributes(active: false)
			end
			part_action.update_attributes(active: true)
			redirect_to request.referrer
		else
			part_action.update_attributes(active: false)
			redirect_to request.referrer
		end
	end

	private

	def part_action_params
		params.require(:part_action).permit(:part_id, :price, :actionimage, :active)
	end
end
