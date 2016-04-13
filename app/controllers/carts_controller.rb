class CartsController < ApplicationController
	def index
		@cart = Cart.where(user_id: current_user.id, purchased: false).first
		@cart_items = CartItem.where(cart_id: @cart.id ).order('id ASC') 
		@coupon_code = @cart.coupon_code || "None"
		@colspan = @cart.coupon_code.blank? ? 3 : 4
		coupon = Coupon.where(code: @coupon_code).first
		@coupon = Coupon.where(code: @coupon_code).first
		weight_array = [0, 1000, 2000, 3000, 4000, 5000, 6000]
		shipping_array = [0.50, 1, 1.50, 2, 2.50, 3]
		@shipping_cost = 0
		@cart_price_total = 0
		message = []
		@cart_items.each do |item|
			item.price = DiscountPrice.where(part_id: item.part_id, amount: 0..(item.amount)).last.price
			item.save

			part = Part.find(item.part_id)
			if item.amount > part.stock
				message << "There #{part.stock == 1 ? 'is' : 'are'} only #{part.stock} #{"product".pluralize(part.stock)} in stock for '#{part.name}'"
				flash.now[:danger] = message
			end

 			if !coupon.blank?
	 			if coupon.amount > 0 && coupon.expiration_date > Time.now.utc
					if coupon.part_ids.empty? && coupon.category_ids.empty? && !coupon.user_ids.empty?	
						if coupon.user_ids.include?(@cart.user_id)
							if !coupon.price.blank?
								item.price_sale = item.price - coupon.price
								item.save
							else
								item.price_sale = item.price - (item.price / 100 * coupon.percent)
								item.save
							end
						else
							item.price_sale = nil
							item.save
						end
					elsif coupon.user_ids.empty?
						if coupon.category_ids.include?(item.part.category_id) || coupon.part_ids.include?(item.part.id)
							if !coupon.price.blank?
								item.price_sale = item.price - coupon.price
								item.save
							else
								item.price_sale = item.price - (item.price / 100 * coupon.percent)
								item.save
							end	
						else
							item.price_sale = nil
							item.save
						end
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						if (coupon.category_ids.include?(item.part.category_id) && coupon.user_ids.include?(@cart.user_id)) || (coupon.part_ids.include?(item.part.id) && coupon.user_ids.include?(@cart.user_id))
							if !coupon.price.blank?
								item.price_sale = item.price - coupon.price
								item.save
							else
								item.price_sale = item.price - (item.price / 100 * coupon.percent)
								item.save
							end
						else
							item.price_sale = nil
							item.save
						end
					end
				else
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon invalid"
				end
			end

			@cart_price_total += ((item.price_sale || item.price) * item.amount)

			if @cart.delivery_method == "Shipping"
				if item.part.weight.between?(weight_array[0], weight_array[1] - 1)
					@shipping_cost += item.amount * shipping_array[0]
				elsif item.part.weight.between?(weight_array[1], weight_array[2] - 1)
					@shipping_cost += item.amount * shipping_array[1]
				elsif item.part.weight.between?(weight_array[2], weight_array[3] - 1)
					@shipping_cost += item.amount * shipping_array[2]
				elsif item.part.weight.between?(weight_array[3], weight_array[4] - 1)
					@shipping_cost += item.amount * shipping_array[3]
				elsif item.part.weight.between?(weight_array[4], weight_array[5] - 1)
					@shipping_cost += item.amount * shipping_array[4]
				elsif item.part.weight.between?(weight_array[5], weight_array[6] - 1)
					@shipping_cost += item.amount * shipping_array[5]
				end
			end
		end
	end

	def edit
		@cart = Cart.find(params[:id])
	end

	def update
		@cart = Cart.find(params[:id])

		if params[:cart][:coupon_code].present?
			coupon = Coupon.where(code: params[:cart][:coupon_code]).first
			cart_items = CartItem.where(cart_id: params[:id])

			is_already_saved = false
			if !coupon.blank? && coupon.amount > 0 && coupon.expiration_date > Time.now.utc && !current_user.used_coupon_ids.include?(coupon.id)
				cart_items.each do |item|
					if coupon.part_ids.empty? && coupon.category_ids.empty? && !coupon.user_ids.empty?	
						if coupon.user_ids.include?(@cart.user_id)
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
					elsif coupon.user_ids.empty?
						if coupon.category_ids.include?(item.part.category_id) || coupon.part_ids.include?(item.part.id)
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
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						if (coupon.category_ids.include?(item.part.category_id) && coupon.user_ids.include?(@cart.user_id)) || (coupon.part_ids.include?(item.part.id) && coupon.user_ids.include?(@cart.user_id))
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
				end
				if is_already_saved
					redirect_to user_carts_path(current_user)
					flash[:success] = "Coupon applied"
				else
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon isn't useable on any items in this cart"
				end
	    else
	    	cart_items.each do |item|
	    		item.price_sale = nil
	    		item.save
	    	end
	    	@cart.coupon_code = nil
	    	@cart.save
	      redirect_to user_carts_path(current_user)
	      flash[:notice] = "Coupon invalid"
	    end
	  else
	  	@cart.update(cart_params)
	  	render inline: 'Changed delivery method' # Needed for Javascript response
	  end
	end

	def purchase
		user = User.find(current_user.id)
		cart_id = params[:cart_id]
		coupon = Coupon.where(code: params[:coupon_code]).first
		cart = Cart.find(cart_id)
		cart_items = CartItem.where(cart_id: cart_id)
		errors = 0
		if !Invoice.where(user_id: current_user.id, cart_id: cart.id).exists?
			cart_items.each do |item|
				part = Part.find(item.part_id)
				if !((part.stock - item.amount) < 0)	
					part.stock -= item.amount
					part.save
				else
					errors += 1
				end
			end
			if errors == 0
				cart.purchased = true
				cart.save
				Invoice.create(user_id: current_user.id, cart_id: cart_id)
				Cart.create(user_id: current_user.id, delivery_method: "Shipping")
				if !coupon.blank?
					user.used_coupon_ids << coupon.id
					user.save
				end
				if !coupon.blank? && coupon.amount > 0
					coupon.amount -= 1
					coupon.save
				end
			end
			render inline: 'Purchase succeeded' # Needed for Javascript response
		else
			render inline: 'Purchase failed' # Needed for Javascript response
		end
	end

	private

	def cart_params
		params.require(:cart).permit(:user_id, :purchased, :coupon_code, :delivery_method)
	end
end
