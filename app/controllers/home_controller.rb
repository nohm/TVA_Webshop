class HomeController < ApplicationController

	def search
  	if flash[:item_added]
      @cart = Cart.where(user_id: current_user.id, purchased: false).first
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end
		@reminder = Reminder.new
		@cart_item = CartItem.new
		@query = params[:search_query]
		search_condition = '%' + @query + '%'

		product_results = []
		part_results = []
		category_results = []
		@product_results = []
		@part_results = []
		@category_results = []
		
		if !@query.match(/([a-zA-Z0-9])+/).blank?
			product_results += Product.where('brand ILIKE ? OR type_number ILIKE ? OR partnumber ILIKE ? OR model ILIKE ? OR model_extended ILIKE ?', search_condition, search_condition, search_condition, search_condition, search_condition).order('id')
			part_results += Part.where('brand ILIKE ? OR name ILIKE ?', search_condition, search_condition).order('id')
			category_results += Category.where('name ILIKE ?', search_condition).order('id')

			@product_results = Kaminari.paginate_array(product_results).page(params[:product_page]).per(10)
			@part_results = Kaminari.paginate_array(part_results).page(params[:part_page]).per(5)
			@category_results = Kaminari.paginate_array(category_results).page(params[:category_page]).per(10)
		end
	end

	def search_model_extended
		id = params[:id]
		brand = params[:brand]
		model = params[:model]
		model_extended = params[:model_extended]

		# Products search through model_extended
		if !model_extended.blank?
			product = Product.find_by(device_id: id, brand: brand, model_extended: model_extended)
				render :js => "window.location = '#{device_product_categories_path(product.device_id, product)}'"
		end
	end

	def all_parts
  	if flash[:item_added]
      @cart = Cart.where(user_id: current_user.id, purchased: false).first
      @cart_items = CartItem.where(:cart_id => @cart.id).order('id')
    end
		@reminder = Reminder.new
		@cart_item = CartItem.new
		@all_parts = Part.where(category_id: params[:category_id]).page(params[:page]).per(20).order('id ASC')
	end

	def part
		if flash[:item_added]
      @cart = Cart.where(user_id: current_user.id, purchased: false).first
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end
		@reminder = Reminder.new
		@cart_item = CartItem.new
		@part = Part.find(params[:part_id])
		@stock = PartStock.where(part_id: @part.id).sum('stock')
    @partimages = Partimage.where(part_id: params[:part_id])
    @descriptions = Partdescription.where(part_id: params[:part_id]).order('title ASC')
    @discount_prices = DiscountPrice.where(part_id: params[:part_id]).order('amount ASC')
	end

	def suitable_products
		@part = Part.find(params[:part_id])
		@connections = @part.parts_products.page(params[:page]).per(1)
	end

	def invoices
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@invoices = Invoice.all.page(params[:page]).per(25)
	end

	def options_device
		if !params[:id].blank?
	    id = params[:id]

 		  if !id.blank?
		    render :partial => 'options_device'
			end
		elsif !params[:p_id].blank?
			id = params[:p_id]

	    if !id.blank?
	    	product = Product.find(id)
	    	@device = Device.find(product.device_id)  
		    render :partial => 'options_device'
			end
		elsif !params[:d_id].blank?
			id = params[:d_id]

			if !id.blank?
				@device = Device.find(id)
				render :partial => 'options_device'
			end
		end
	end

	def options_brand
		if !params[:id].blank?
	    id = params[:id]

	    # Fill in #brand_select
	    if !id.blank?
		    @products = Product.where(device_id: id).pluck(:brand).uniq
		    render :partial => 'options_brand'
			end
		elsif !params[:p_id].blank?
			id = params[:p_id]

			# Fill in #brand_select
	    if !id.blank?
	    	@product = Product.find(id)
		    @products = Product.where(device_id: @product.device_id).pluck(:brand).uniq
		    render :partial => 'options_brand'
			end
		elsif !params[:d_id].blank?
			id = params[:d_id]
			
			if !id.blank?
				@brand = params[:brand]
				@products = Product.where(device_id: id).pluck(:brand).uniq
				render :partial => 'options_brand'
			end
		end
	end

	def options_model
		if !params[:id].blank?	
			id = params[:id]
			brand = params[:brand]

			# Fill in #model_select
			if !brand.blank?
				@products = Product.where(device_id: id, brand: brand).pluck(:model).uniq
				render :partial => 'options_model'
			end
		elsif !params[:p_id].blank?
			id = params[:p_id]
			
			# Fill in #model_select
			if !id.blank?
				@product = Product.find(id)
				@products = Product.where(device_id: @product.device_id, brand: @product.brand).pluck(:model).uniq
				render :partial => 'options_model'
			end
		elsif !params[:d_id].blank?
			id = params[:d_id]

			if !id.blank?
				@model = params[:model]
				@products = Product.where(device_id: id, brand: params[:brand]).pluck(:model).uniq
				render :partial => 'options_model'
			end
		end
	end

	def options_model_extended
		if !params[:id].blank?
			id = params[:id]
			brand = params[:brand]
			model = params[:model]

			# Products search through model
			if !model.blank? && !Product.where(model: model, device_id: id).pluck(:model_extended).any?
				product = Product.find_by(device_id: id, brand: brand, model: model)
				unless product.blank?
					render :js => "window.location = '#{device_product_categories_path(product.device_id, product)}'"
					return
				end
			end

			# Fill in #model_extended_select
			if !model.blank?
				@products = Product.where(device_id: id, brand: brand, model: model).pluck(:model_extended).uniq
				render :partial => 'options_model_extended'
			end
		elsif !params[:p_id].blank?
			id = params[:p_id]

			# Fill in #model_extended_select
			if !id.blank?
				@product = Product.find(id)
				@products = Product.where(device_id: @product.device_id, brand: @product.brand, model: @product.model).pluck(:model_extended).uniq
				if !@products.include?(nil)
					render :partial => 'options_model_extended'
				else
					render inline: 'No Extended' # Needed for Javascript response
				end
			end
		elsif !params[:d_id].blank?
			id = params[:d_id]

			# Fill in #model_extended_select
			if !id.blank?
				@products = Product.where(device_id: id, brand: params[:brand], model: params[:model]).pluck(:model_extended).uniq
				if !@products.include?(nil)
					render :partial => 'options_model_extended'
				else
					render inline: 'No Extended' # Needed for Javascript response
				end
			end
		end
	end
end

