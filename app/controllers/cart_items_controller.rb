class CartItemsController < ApplicationController
	def create 
		if CartItem.where(part_id: params[:cart_item][:part_id], cart_id: params[:cart_item][:cart_id]).exists?
			cart_item = CartItem.where(cart_id: params[:cart_item][:cart_id], part_id: params[:cart_item][:part_id])
			cart_item.update_all(amount: (cart_item.first.amount + params[:cart_item][:amount].to_i))
			redirect_to user_carts_path(current_user)
		else
			cart_item = CartItem.new(cart_item_params)
			if cart_item.save
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
		@cart_item = CartItem.find(params[:id])
		respond_to do |format|
			if params[:cart_item][:amount].to_i <= @cart_item.part.stock
				if params[:cart_item][:amount].to_i > 0	
		      if @cart_item.update_attributes(cart_item_params)
		        format.html { render inline: "Geslaagd"}
		        format.js
		      else
		      	format.html { render inline: "Gefaald"}
		      	format.js
		      end
		    else
		     	flash[:notice] = "Uw aantal kan niet kleiner zijn dan 1"
		     	format.html { render inline: "Aantal is niet geldig"}
		    end
	    else
	    	flash[:notice] = "There are only " + @cart_item.part.stock.to_s + " parts remaining for this product."
	    	format.html { render inline: "Niet genoeg onderdelen"}
	    end
	  end
	end

	private

	def cart_item_params
		params.require(:cart_item).permit(:cart_id, :part_id, :amount, :price)
	end
end
