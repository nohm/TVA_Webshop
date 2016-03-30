class CartsController < ApplicationController
	def index
		@cart = Cart.where(user_id: params[:user_id], purchased: false).first
		@cart_items = CartItem.where(cart_id: @cart.id )

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

	def edit
		@cart = Cart.find(params[:id])
	end

	def update
		@cart = Cart.find(params[:id])

		if Coupon.where(code: params[:cart][:coupon_code]).exists?
			if @cart.update(cart_params)
				redirect_to user_carts_path(current_user)
      	flash[:success] = "Coupon added"
			else
      	render 'edit'
      end
    else
      redirect_to user_carts_path(current_user)
      	flash[:notice] = "Coupon invalid"
    end
	end

	def purchase
		cart_id = params[:cart_id]
		cart = Cart.find(cart_id)
		cart_items = CartItem.where(cart_id: cart_id)
		errors = 0
		cart_items.each do |item|
			part = Part.find(item.part_id)
			if !((part.stock - item.amount) < 0)	
				part.stock -= item.amount
				part.save
			else
				flash[:notice] = "There #{part.stock == 1 ? 'is' : 'are'} only #{part.stock} #{"product".pluralize(part.stock)} in stock for '#{part.name}'"
				errors += 1
			end
		end
		if errors == 0
			cart.purchased = true
			cart.save
			Invoice.create(user_id: current_user.id, cart_id: cart_id)
			Cart.create(user_id: current_user.id)
		end
		render :js => "window.location = location"
	end

	private

	def cart_params
		params.require(:cart).permit(:user_id, :purchased, :coupon_code)
	end
end
