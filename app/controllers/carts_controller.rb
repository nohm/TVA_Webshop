class CartsController < ApplicationController
	def index
		@carts = Cart.where(user_id: current_user.id, purchased: false).order('id ASC')
	end

	def create
		if Cart.where(user_id: params[:cart][:user_id], part_id: params[:cart][:part_id], purchased: false).exists?
			cart = Cart.where(user_id: params[:cart][:user_id], part_id: params[:cart][:part_id], purchased: false)
			Cart.where(user_id: params[:cart][:user_id], part_id: params[:cart][:part_id], purchased: false).update_all(amount: (cart.first.amount + params[:cart][:amount].to_i), updated_at: Time.now)
			@carts = Cart.where(user_id: current_user.id)
			redirect_to carts_path
		else
			@cart = Cart.new(cart_params)
			if @cart.save
	      redirect_to carts_path
	    end
	  end
	end

	def destroy
		cart = Cart.find(params[:id])
    cart.destroy
    redirect_to carts_path
	end

	def update
		@cart = Cart.find(params[:id])
		respond_to do |format|
			if params[:cart][:amount].to_i <= @cart.part.stock
				if params[:cart][:amount].to_i > 0	
		      if @cart.update_attributes(cart_params)
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
	    	flash[:notice] = "Er zijn nog maar " + @cart.part.stock.to_s + " onderdelen beschikbaar voor dit product"
	    	format.html { render inline: "Niet genoeg onderdelen"}
	    end
	  end
	end

	def purchase
		cart_ids = params[:cart_ids]
		user = params[:user_id]
		carts = Cart.where(id: cart_ids, user_id: user)
		#invoice = Invoice.create(:user_id => current_user.id)
		carts.each do |cart|
			cart.purchased = true
			part = Part.find(cart.part_id)
			part.stock -= cart.amount
			#Invoice_Items.create(invoice_id: invoice.id, cart_id: cart.id)
			part.save
			cart.save
		end 
		Invoice.create(user_id: current_user.id, cart_ids: cart_ids)
		render :js => "window.location = location"
	end

	private

	def cart_params
		params.require(:cart).permit(:user_id, :part_id, :amount, :purchased)
	end
end
