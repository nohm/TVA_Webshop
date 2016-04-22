class CartItemsController < ApplicationController
	def create
		cart_id = params[:cart_item][:cart_id]
		part_id = params[:cart_item][:part_id]
		amount = params[:cart_item][:amount].to_i
		cart = Cart.find(cart_id)

		if CartItem.where(part_id: part_id, cart_id: cart_id).exists?
			cart_item = CartItem.find_by(cart_id: cart_id, part_id: part_id)
			part = Part.find(part_id)
			stock = PartStock.where(part_id: part.id).sum('stock')
			if cart_item.amount + amount > stock
				discount_price = DiscountPrice.where(part_id: part_id, amount: 0..(stock)).last
				cart_item.update_columns(amount: stock, price_tier_discount: discount_price.price, discount_tier: discount_price.amount)
			else
				discount_price = DiscountPrice.where(part_id: part_id, amount: 0..(cart_item.amount + amount)).last
				cart_item.update_columns(amount: (cart_item.amount + amount), price_tier_discount: discount_price.price, discount_tier: discount_price.amount)
			end
			cart.update_attribute(:previous_url, request.referrer)
			flash[:item_added] = "Toggle modal"
			redirect_to :back
		else
			params[:cart_item][:price] = DiscountPrice.where(part_id: part_id, amount: 0..(amount)).first.price
			params[:cart_item][:name] = Part.find(part_id).name
			params[:cart_item][:discount_tier] = DiscountPrice.where(part_id: part_id, amount: 0..(amount)).last.amount
			params[:cart_item][:price_tier_discount] = DiscountPrice.where(part_id: part_id, amount: 0..(amount)).last.price
			cart_item = CartItem.new(cart_item_params)
			if cart_item.save
				cart.update_attribute(:previous_url, request.referrer)
				flash[:item_added] = "Toggle modal"
		    redirect_to :back
		  end
		end
	end

	def destroy
    cart_item = CartItem.find(params[:id])
    cart = Cart.find(cart_item.cart_id)
    cart_item.destroy
    if CartItem.where(cart_id: cart.id).blank?
    	cart.update_attribute(:coupon_code, nil)
    end
    redirect_to user_carts_path(current_user)
	end

	def update
		cart_item = CartItem.find(params[:id])
		cart = Cart.where(user_id: current_user, purchased: false).first
		
		unless cart.coupon_code.blank?
			coupon = Coupon.where(code: cart.coupon_code).first
		end

		if params[:cart_item][:amount].to_i <= PartStock.where(part_id: cart_item.part.id).sum('stock')
			if params[:cart_item][:amount].to_i > 0	
				params[:cart_item][:discount_tier] = DiscountPrice.where(part_id: cart_item.part_id, amount: 0..(params[:cart_item][:amount].to_i)).last.amount
		    if cart_item.update_attributes(cart_item_params)
		      render inline: "Succeeded"
		    else
		    	render inline: "Failed"    	
		    end
		  else
		   	flash[:notice] = "The amount can't be smaller than 1"
		   	render inline: "Amount is not valid"
		  end
	  else
	  	flash[:notice] = "There are only " + PartStock.where(part_id: cart_item.part.id).sum('stock').to_s + " parts remaining for this product."
	  	render inline: "Not enough products"
	  end
	end

	private

	def cart_item_params
		params.require(:cart_item).permit(:cart_id, :part_id, :amount, :price, :name, :discount_tier, :price_tier_discount)
	end
end
