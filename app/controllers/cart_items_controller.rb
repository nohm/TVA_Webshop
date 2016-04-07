class CartItemsController < ApplicationController
	def create 
		if CartItem.where(part_id: params[:cart_item][:part_id], cart_id: params[:cart_item][:cart_id]).exists?
			cart_item = CartItem.where(cart_id: params[:cart_item][:cart_id], part_id: params[:cart_item][:part_id])
			cart_item.update_all(amount: (cart_item.first.amount + params[:cart_item][:amount].to_i))
			flash[:cart] = "Continue shopping"
			redirect_to user_carts_path(current_user)
		else
			amount = params[:cart_item][:amount].to_i
			part_id = params[:cart_item][:part_id]
			params[:cart_item][:price] = DiscountPrice.where(part_id: part_id, amount: 0..(amount)).last.price
			cart_item = CartItem.new(cart_item_params)
			if cart_item.save
				flash[:cart] = "Continue shopping"
		    redirect_to user_carts_path(current_user)
		  end
		end
	end

	def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to user_carts_path(current_user)
	end

	def update
		cart_item = CartItem.find(params[:id])
		cart = Cart.where(user_id: current_user, purchased: false).first
		if !cart.coupon_code.blank?
			coupon = Coupon.where(code: cart.coupon_code).first
		end
		if params[:cart_item][:amount].to_i <= cart_item.part.stock
			if params[:cart_item][:amount].to_i > 0	
		    if cart_item.update_attributes(cart_item_params)
		      render inline: "Geslaagd"
		    else
		    	render inline: "Gefaald"    	
		    end
		  else
		   	flash[:notice] = "Uw aantal kan niet kleiner zijn dan 1"
		   	render inline: "Aantal is niet geldig"
		  end
	  else
	  	flash[:notice] = "There are only " + cart_item.part.stock.to_s + " parts remaining for this product."
	  	render inline: "Niet genoeg onderdelen"
	  end
	end

	private

	def cart_item_params
		params.require(:cart_item).permit(:cart_id, :part_id, :amount, :price)
	end
end
