class CartsController < ApplicationController
	def index
		@cart = Cart.where(user_id: current_user.id, purchased: false).first
		@cart_items = CartItem.where(cart_id: @cart.id ).order('id ASC') 
		@coupon_code = @cart.coupon_code || "None"
		@colspan = @cart.coupon_code.blank? ? 5 : 6
		coupon = Coupon.where(code: @coupon_code).first
		weight_array = [1, 10000, 30000]
		shipping_array = [6.95, 13.25]
		@shipping_cost = 0
		@cart_price_discount = 0
		@cart_price_total = 0
		total_weight = 0
		message = []
		is_already_saved = false
		@cart_items.each do |item|
			item.discount_tier = DiscountPrice.where(part_id: item.part_id, amount: 0..(item.amount)).last.amount
			item.price_tier_discount = DiscountPrice.where(part_id: item.part_id, amount: 0..(item.amount)).last.price
			item.save

			part = Part.find(item.part_id)
			stock = PartStock.where(part_id: part.id).sum('stock')
			if item.amount > stock
				if stock > 0
					message << "There #{stock == 1 ? 'is' : 'are'} only #{stock} #{"product".pluralize(stock)} in stock for '#{part.name}'"
				else
					message << "There are no products in stock for '#{part.name}'"
				end
				flash.now[:danger] = message
			end

 			if !coupon.blank?
	 			if coupon.amount > 0 && coupon.expiration_date > Time.now.utc
					if coupon.part_ids.empty? && coupon.category_ids.empty? && !coupon.user_ids.empty?	
						if coupon.user_ids.include?(@cart.user_id)
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							is_already_saved = true	
						else
							item.price_coupon_discount = nil
							item.save
						end
					elsif coupon.user_ids.empty?
						if coupon.category_ids.include?(item.part.category_id) || coupon.part_ids.include?(item.part.id)
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							is_already_saved = true		
						else
							item.price_coupon_discount = nil
							item.save
						end
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						if (coupon.category_ids.include?(item.part.category_id) && coupon.user_ids.include?(@cart.user_id)) || (coupon.part_ids.include?(item.part.id) && coupon.user_ids.include?(@cart.user_id))
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							is_already_saved = true	
						else
							item.price_coupon_discount = nil
							item.save
						end
					end
					if is_already_saved == false
						@cart.coupon_code = nil
						@cart.save
						redirect_to user_carts_path(current_user)
						flash[:notice] = "Coupon isn't useable on any items in this cart"
					end
				else
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon invalid"
				end
			elsif !@cart.coupon_code.blank?
				@cart.coupon_code = nil
				@cart.save
				redirect_to user_carts_path(current_user)
				flash[:notice] = "Coupon invalid"
			end

			@cart_price_total += (item.price_tier_discount * item.amount)

			if @cart.delivery_method == "Shipping"
				total_weight += (item.part.weight * item.amount)
			end

			unless item.price_coupon_discount.blank?
				@cart_price_discount += ((item.price_tier_discount * item.amount) - (item.price_coupon_discount * item.amount))
			end
		end

		if @cart_price_discount != 0
			@cart_price_total_discount = @cart_price_total - @cart_price_discount
		else
			@cart_price_total_discount = @cart_price_total
		end
		
		if total_weight.between?(weight_array[0], weight_array[1] - 1)
			@shipping_cost = shipping_array[0]
		elsif total_weight.between?(weight_array[1], weight_array[2] - 1)
			@shipping_cost = shipping_array[1]
		elsif total_weight >= weight_array[2]
			@shipping_cost = shipping_array[1]
		end

		@cart.shipping_cost = @shipping_cost
		@cart.save
	end

	def edit
		@cart = Cart.find(params[:id])
	end

	def update
		@cart = Cart.find(params[:id])

		if params[:cart][:delivery_method].blank? && params[:cart][:location_id].blank?
			coupon = Coupon.where(code: params[:cart][:coupon_code]).first
			cart_items = CartItem.where(cart_id: params[:id])

			is_already_saved = false
			if !coupon.blank? && coupon.amount > 0 && coupon.expiration_date > Time.now.utc && !current_user.used_coupon_ids.include?(coupon.id)
				cart_items.each do |item|
					if coupon.part_ids.empty? && coupon.category_ids.empty? && !coupon.user_ids.empty?	
						if coupon.user_ids.include?(@cart.user_id)
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							@cart.update(cart_params) unless is_already_saved
							is_already_saved = true	
						else
							item.price_coupon_discount = nil
							item.save
						end
					elsif coupon.user_ids.empty?
						if coupon.category_ids.include?(item.part.category_id) || coupon.part_ids.include?(item.part.id)
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							@cart.update(cart_params) unless is_already_saved
							is_already_saved = true	
						else
							item.price_coupon_discount = nil
							item.save
						end
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						if (coupon.category_ids.include?(item.part.category_id) && coupon.user_ids.include?(@cart.user_id)) || (coupon.part_ids.include?(item.part.id) && coupon.user_ids.include?(@cart.user_id))
							if !coupon.price.blank?
								item.price_coupon_discount = item.price_tier_discount - coupon.price
								item.save
							else
								item.price_coupon_discount = item.price_tier_discount - (item.price_tier_discount / 100 * coupon.percent)
								item.save
							end
							@cart.update(cart_params) unless is_already_saved
							is_already_saved = true	
						else
							item.price_coupon_discount = nil
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
	    		item.price_coupon_discount = nil
	    		item.save
	    	end
	    	@cart.coupon_code = nil
	    	@cart.save
	      redirect_to user_carts_path(current_user)
	      flash[:notice] = "Coupon invalid"
	    end
		elsif params[:cart][:location_id].blank?
		  params[:cart][:location_id] = nil
		  @cart.update(cart_params)
		  render inline: 'Changed delivery method' # Needed for Javascript response
	  elsif params[:cart][:delivery_method].blank?
	  	@cart.update(cart_params)
	  	render inline: 'Changed location' # Needed for Javascript response
	  end
	end

	def purchase
		user = User.find(current_user.id)
		cart_id = params[:cart_id]
		coupon = Coupon.where(code: params[:coupon_code]).first
		cart = Cart.find(cart_id)
		cart_items = CartItem.where(cart_id: cart_id)
		errors = false
		if !Invoice.where(user_id: current_user.id, cart_id: cart.id).exists?
			cart_items.each do |item|
				part = Part.find(item.part_id)
				part_stocks = PartStock.where(part_id: part.id).order('stock DESC')
				purchase_amount = item.amount

				if (part_stocks.sum('stock') - item.amount) >= 0
					if cart.delivery_method == "Shipping"
						part_stocks.each do |part_stock|
							if (part_stock.stock - item.amount) >= 0
								part_stock.stock -= item.amount
								part_stock.save
								break
							else
								if part_stock.stock < purchase_amount
									purchase_amount -= part_stock.stock
									part_stock.stock = 0
									part_stock.save
								else
									part_stock.stock -= purchase_amount
									part_stock.save
									purchase_amount = 0
									break
								end
							end
						end
					elsif cart.delivery_method == "Pick up"
						location_stock = PartStock.find_by(part_id: part.id, location_id: cart.location_id)
						if location_stock.stock > purchase_amount
							location_stock.stock -= item.amount
							location_stock.save
						elsif location_stock.stock < purchase_amount
							purchase_amount -= location_stock.stock
							location_stock.stock = 0
							location_stock.save
							if purchase_amount != 0
								part_stocks.each do |part_stock|
									if part_stock.stock < purchase_amount
										purchase_amount -= part_stock.stock
										part_stock.stock = 0
										part_stock.save
									else
										part_stock.stock -= purchase_amount
										part_stock.save
										purchase_amount = 0
										break
									end
								end
							end
						end
					end
				else
					errors = true
				end
			end
			if errors == false
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
		params.require(:cart).permit(:user_id, :purchased, :coupon_code, :delivery_method, :location_id)
	end
end
