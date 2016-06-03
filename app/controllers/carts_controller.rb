class CartsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && params[:user_id].to_i == current_user.id
		# Checks if user already has a cart, if not create one
		if Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress")).blank?
      @cart = Cart.create(user_id: current_user.id, delivery_method: "Shipping", cart_status_id: search_status_id("In progress"))
    else
    	@cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
    end
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
		pick_up_ready = true

		@cart_items.each do |item|
			item.discount_tier = DiscountPrice.where(part_id: item.part_id, amount: 0..(item.amount)).last.amount
			item.price_tier_discount = DiscountPrice.where(part_id: item.part_id, amount: 0..(item.amount)).last.price
			item.save

			# Checks if the item amount in the cart isn't higher than the stock
			part = Part.find(item.part_id)
			stock = PartStock.where(part_id: part.id).sum('stock')
			if item.amount > stock
				# Add an error message based on which error it has
				if stock > 0
					message << "There #{stock == 1 ? 'is' : 'are'} only #{stock} #{"product".pluralize(stock)} in stock for '#{part.name}'"
				else
					message << "There are no products in stock for '#{part.name}'"
				end
				flash.now[:danger] = message
			end

			# Checks if the pick up location has enough products in stock
			if @cart.delivery_method == "Pick up" && !@cart.location_id.blank?
				location_stock = PartStock.where(part_id: item.part_id, location_id: @cart.location_id).first
				# Check if the location_stock exists else check if item.amount is higher than l
				if location_stock.blank?
					pick_up_ready = false
				elsif item.amount > location_stock.stock
					pick_up_ready = false
				end
			end

 			if !coupon.blank?
 				# Checks if coupon is still valid
	 			if coupon.amount > 0 && coupon.expiration_date > Time.now.utc
					# Checks if the coupon only have user_ids and than does a check if the coupon can be used on the current cart
					# Used if entire cart can get a discount for only certain users
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
					# Checks if user_ids are empty
					elsif coupon.user_ids.empty?
						# Checks if the current item either has a category id or part id that is included in the coupon
						# Used if items can get a discount based on their category / part id
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
					# Checks if user_ids, part_ids and category_ids / user_ids and category_ids / user_ids and part_ids are filled in
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						# Checks if the current user and the current item has a category / part id that are included in the coupon 
						# Used if certain users can get a discount on specific categories / parts
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

					# Checks if the coupon doesn't apply to any of the items in the cart, if so remove the coupon from the cart and give an error message
					if is_already_saved == false
						@cart.coupon_code = nil
						@cart.save
						redirect_to user_carts_path(current_user)
						flash[:notice] = "Coupon isn't useable on any items in this cart"
					end
				# If the coupon is not valid remove price_coupon_discount from every item in the cart, remove the coupon from the cart and give an error message
				else
					@cart_items.each do |cart_item|
						cart_item.price_coupon_discount = nil
						cart_item.save
					end
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon invalid"
				end
			# If @cart.coupon code is not blank remove price_coupon_discount from every item in the cart, remove the coupon from the cart and give an error message
			elsif !@cart.coupon_code.blank?
				@cart_items.each do |cart_item|
					cart_item.price_coupon_discount = nil
					cart_item.save
				end
				@cart.coupon_code = nil
				@cart.save
				redirect_to user_carts_path(current_user)
				flash[:notice] = "Coupon invalid"
			end

			# Add the current item price to the total price
			@cart_price_total += (item.price_tier_discount * item.amount)

			# If the delivery method is "Shipping" add the current items weight to the total weight
			if @cart.delivery_method == "Shipping"
				total_weight += (item.part.weight * item.amount)
			end

			# If the item has a discounted price because of a coupon, add the discount from the current item to the total discount
			unless item.price_coupon_discount.blank?
				@cart_price_discount += ((item.price_tier_discount * item.amount) - (item.price_coupon_discount * item.amount))
			end
		end

		# Set the total price of a purchase here, if there is a coupon remove the discount from the total price
		if @cart_price_discount != 0
			@cart_price_total_discount = @cart_price_total - @cart_price_discount
		else
			@cart_price_total_discount = @cart_price_total
		end
		
		# Determines shipping cost based on total weight
		if total_weight.between?(weight_array[0], weight_array[1] - 1)
			@shipping_cost = shipping_array[0]
		elsif total_weight.between?(weight_array[1], weight_array[2] - 1)
			@shipping_cost = shipping_array[1]
		elsif total_weight >= weight_array[2]
			@shipping_cost = shipping_array[1]
		end

		@cart.shipping_cost = @shipping_cost
		@cart.save

		# If the pick up location doesn't have enough products in stock show an information alert
		if @cart.delivery_method == "Pick up" && !@cart.location_id.blank?
			if pick_up_ready == false
				flash.now[:info] = "Some products are not in stock at the chosen pick up location, you will have to wait a while for it to get shipped. When it arrives you will receive an email."
			end
		end
	end

	def edit
		@cart = Cart.find(params[:id])
	end

	def update
		@cart = Cart.find(params[:id])

		# Checks if update is for updating cart_status_id
		if !params[:cart][:cart_status_id].blank?
			if @cart.update(cart_params)
				# Checks if cart is being updated to the status of "Waiting for pick up", if so send a mail to the customer with a reminder that they can pick up their order
				if params[:cart][:cart_status_id].to_i == search_status_id("Waiting for pick up")
					Mailer.send_order_reminder(@cart).deliver_now
				end
	      redirect_to request.referrer
	      flash[:success] = "Status updated"
	    else
	      redirect_to request.referrer
	      flash[:notice] = "Error while updating"
	    end
	  # Checks if update is for updating coupon_code
		elsif params[:cart][:delivery_method].blank? && params[:cart][:location_id].blank?
			coupon = Coupon.where(code: params[:cart][:coupon_code]).first
			cart_items = CartItem.where(cart_id: params[:id])
			is_already_saved = false

			# Checks if coupon is still valid
			if !coupon.blank? && coupon.amount > 0 && coupon.expiration_date > Time.now.utc && !current_user.used_coupon_ids.include?(coupon.id)
				cart_items.each do |item|
					# Checks if the coupon only have user_ids and than does a check if the coupon can be used on the current cart
					# Used if entire cart can get a discount for only certain users
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
					# Checks if user_ids are empty
					elsif coupon.user_ids.empty?
						# Checks if the current item either has a category id or part id that is included in the coupon
						# Used if items can get a discount based on their category / part id
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
					# Checks if user_ids, part_ids and category_ids / user_ids and category_ids / user_ids and part_ids are filled in
					elsif (!coupon.user_ids.empty? && !coupon.part_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.category_ids.empty?) || (!coupon.user_ids.empty? && !coupon.part_ids.empty?)
						# Checks if the current user and the current item has a category / part id that are included in the coupon 
						# Used if certain users can get a discount on specific categories / parts
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

				# Checks if is_already_saved is true
				if is_already_saved
					redirect_to user_carts_path(current_user)
					flash[:success] = "Coupon applied"
				# Checks if is_already_saved is false, if so remove the coupon from the cart and give an error message
				elsif is_already_saved == false
					@cart.coupon_code = nil
					@cart.save
					redirect_to user_carts_path(current_user)
					flash[:notice] = "Coupon isn't useable on any items in this cart"
				end
			# If the coupon is not valid remove price_coupon_discount from every item in the cart, remove the coupon from the cart and give an error message
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
	  # Checks if update is for updating delivery_method, if so update the cart
		elsif params[:cart][:location_id].blank?
		  params[:cart][:location_id] = nil
		  if @cart.update(cart_params)
			  @cart.update(cart_params)
			  render inline: 'Changed delivery method' # Needed for Javascript response
			else
				render inline: 'Failed to change delivery method' # Needed for Javascript response
			end
	  # Checks if update is for updating location, if so update the cart
	  elsif params[:cart][:delivery_method].blank?
	  	if @cart.update(cart_params)
	  		@cart.update(cart_params)
	  		render inline: 'Changed location' # Needed for Javascript response
	  	else
	  		render inline: 'Failed to change location' # Needed for Javascript response
	  	end
	  end
	end

	def purchase
		user = User.find(current_user.id)
		cart_id = params[:cart_id]
		coupon = Coupon.where(code: params[:coupon_code]).first
		cart = Cart.find(cart_id)
		cart_items = CartItem.where(cart_id: cart_id)
		errors = false
		ready_for_delivery = false
		not_ready_for_delivery = false
		delivery_ids = []

		# Checks if there isn't already an invoice with the same user and cart
		if !Invoice.where(user_id: user.id, cart_id: cart.id).exists?
			cart_items.each do |item|
				part = Part.find(item.part_id)
				part_stocks = PartStock.where(part_id: part.id).order('stock DESC')
				purchase_amount = item.amount
				
				# Checks if the entire stock for a part is higher or equal to the amount being purchased
				if part_stocks.sum('stock') >= item.amount
					if cart.delivery_method == "Shipping"
						part_stocks.each do |part_stock|
							# Checks if the stock in a location is higher or equal to the amount being purchased
							if part_stock.stock >= item.amount
								part_stock.stock -= item.amount
								part_stock.save
								delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: part_stock.location_id, shipping_to_user: cart.user_id, amount: item.amount, cart_status_id: search_status_id("Ready for shipping to client"))
								delivery_ids << delivery.id
								break
							else
								# Checks if the stock in a location is lower to the amount being purchased
								if part_stock.stock < purchase_amount
									delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: part_stock.location_id, shipping_to_user: cart.user_id, amount: part_stock.stock, cart_status_id: search_status_id("Ready for shipping to client"))
									delivery_ids << delivery.id
									purchase_amount -= part_stock.stock
									part_stock.stock = 0
									part_stock.save
								else
									delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: part_stock.location_id, shipping_to_user: cart.user_id, amount: purchase_amount, cart_status_id: search_status_id("Ready for shipping to client"))
									delivery_ids << delivery.id
									part_stock.stock -= purchase_amount
									part_stock.save
									purchase_amount = 0
								end
							end
						end
						ready_for_delivery = true
					elsif cart.delivery_method == "Pick up"
						location_stock = PartStock.find_by(part_id: part.id, location_id: cart.location_id)
						# Checks if the pick up location has any stock for the part and if the location stock is higher or equal to the amount being purchased
						if !location_stock.blank? && location_stock.stock >= purchase_amount
							delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: cart.location_id, shipping_to_location: cart.location_id, amount: purchase_amount, cart_status_id: search_status_id("Waiting for pick up"))
							delivery_ids << delivery.id
							location_stock.stock -= item.amount
							location_stock.save
							ready_for_delivery = true
						else
							# Checks if the pick up location has any stock for the part
							if !location_stock.blank?
								purchase_amount -= location_stock.stock
								delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: cart.location_id, shipping_to_location: cart.location_id, amount: location_stock.stock, cart_status_id: search_status_id("Waiting for pick up"))
								delivery_ids << delivery.id
								location_stock.stock = 0
								location_stock.save
							end
							part_stocks.each do |part_stock|
								# Break out of the loop if purchase_amount is equal or lower than 0
								break if purchase_amount <= 0
								# Checks if the location stock is lower than the amount being purchased
								if part_stock.stock < purchase_amount
									delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: part_stock.location_id, shipping_to_location: cart.location_id, amount: part_stock.stock, cart_status_id: search_status_id("Ready for internal shipping"))
									delivery_ids << delivery.id
									purchase_amount -= part_stock.stock
									part_stock.stock = 0
									part_stock.save
								else
									delivery = Delivery.create(cart_item_id: item.id, shipping_from_location: part_stock.location_id, shipping_to_location: cart.location_id, amount: purchase_amount, cart_status_id: search_status_id("Ready for internal shipping"))
									delivery_ids << delivery.id
									part_stock.stock -= purchase_amount
									part_stock.save
									purchase_amount = 0
								end
							end
						end
						not_ready_for_delivery = true
					end
				else
					errors = true
				end
			end

			# If errors is false complete the purchase
			if errors == false
				# Determines which status a cart gets
				if ready_for_delivery == true && not_ready_for_delivery == false
					if cart.delivery_method == "Shipping"
						cart.cart_status_id = search_status_id("Ready for shipping to client")
					elsif cart.delivery_method == "Pick up"
						cart.cart_status_id = search_status_id("Waiting for pick up")
						Mailer.send_order_reminder(cart).deliver_now
					end
					cart.save
				else
					if cart.delivery_method == "Pick up"
						cart.cart_status_id = search_status_id("Ready for internal shipping")
						cart.save
					end
				end

				cart.order_made_at = Time.now.utc
				if cart.cart_status_id == search_status_id("In progress")
					cart.cart_status_id = search_status_id("Completed")
				end
				cart.save
				Invoice.create(user_id: user.id, cart_id: cart_id)
				Cart.create(user_id: user.id, delivery_method: "Shipping", cart_status_id: search_status_id("In progress"))

				# Check if the cart has a coupon or not
				if !coupon.blank?
					user.used_coupon_ids << coupon.id
					user.save
					# Checks if the coupon amount is higher than 0
					if coupon.amount > 0
						coupon.amount -= 1
						coupon.save
					end
				end
			else
				deliveries = Delivery.find(delivery_ids)
				deliveries.each do |delivery|
					delivery.destroy
				end
			end
			render inline: 'Purchase succeeded' # Needed for Javascript response
		else
			render inline: 'Purchase failed' # Needed for Javascript response
		end
	end

	private

	def cart_params
		params.require(:cart).permit(:user_id, :coupon_code, :delivery_method, :location_id, :cart_status_id, :order_made_at)
	end
end
