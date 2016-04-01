class CartsController < ApplicationController
	def index
		@cart = Cart.where(user_id: params[:user_id], purchased: false).first
		@cart_items = CartItem.where(cart_id: @cart.id ) 
		@coupon_code = @cart.coupon_code || "None"

		weight_array = [0, 999, 1000, 1999, 2000, 2999, 3000, 3999, 4000, 4999, 5000, 5999]
		shipping_array = [0.50, 1, 1.50, 2, 2.50, 3]
		@shipping_cost = 0
		@cart_amount_total = 0
		@cart_price_total = 0
		@cart_items.each do |item|
			@cart_amount_total += item.amount
			@cart_price_total += ((item.price_sale || item.price) * item.amount)

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
		cart_items = CartItem.where(cart_id: params[:id])

		if params[:cart][:coupon_code].blank?
			params[:cart][:coupon_code] = nil
			if @cart.update(cart_params)
				
				cart_items.each do |item|
					item.price_sale = nil
					item.save
				end
				redirect_to user_carts_path(current_user) and return
			end
		end

		is_already_saved = false
		if Coupon.where(code: params[:cart][:coupon_code]).exists? && Coupon.where(code: params[:cart][:coupon_code]).first.amount != 0 && Coupon.where(code: params[:cart][:coupon_code]).first.expiration_date > Time.now.utc
				coupon = Coupon.where(code: params[:cart][:coupon_code]).first
				cart_items.each do |item|	
					if coupon.category_ids.include?(item.part.category_id) || coupon.part_ids.include?(item.part_id) || coupon.user_ids.include?(@cart.user_id) 
						if !coupon.price.blank?
							item.price_sale = item.price - coupon.price
							item.save
						else
							item.price_sale = item.price - (item.price / 100 * coupon.percent)
							item.save
						end
						@cart.update(cart_params) unless is_already_saved
						is_already_saved = true
					else

						item.price_sale = nil
						item.save
					end 
				end
				if is_already_saved == true
					redirect_to user_carts_path(current_user)
					flash[:success] = "Coupon added"
				else
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon invalid"
				end
    else
    	cart_items.each do |item|
    		item.price_sale = nil
    		item.save
    	end
    	@cart.coupon_code = nil
    	@cart.save
      sdk
      redirect_to user_carts_path(current_user)
      flash[:notice] = "Coupon invalid"
    end
	end

	def purchase
		cart_id = params[:cart_id]
		coupon = Coupon.where(code: params[:coupon_code]).first
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
			if coupon.amount > 0
				coupon.amount -= 1
				coupon.save
			end
		end
		render :js => "window.location = location"
	end

	private

	def cart_params
		params.require(:cart).permit(:user_id, :purchased, :coupon_code)
	end
end
