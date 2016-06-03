class HomeController < ApplicationController
	# Search method for products, parts and categories
	# Product search based on brand, model and model_extended
	# Part search based on brand, name and partnumber
	# Category search based on name
	def search
  	# Checks if it can find the flash
  	if flash[:item_added]
  		# Parameters used for the modal _cart_show_modal.html.erb inside parts view
      @cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end

		@reminder = Reminder.new
		@cart_item = CartItem.new
		@query = params[:search_query]
		search_condition = '%' + @query + '%'

		@product_results = []
		@part_results = []
		@category_results = []
		
		# Checks if the query isn't blank and than starts looking for results based on the query and adds the records found to @product_results, @part_results and @category_results
		if !@query.match(/([a-zA-Z0-9])+/).blank?
			@product_results += Product.where('brand ILIKE ? OR model ILIKE ? OR model_extended ILIKE ?', search_condition, search_condition, search_condition).order('id')
			@part_results += Part.where('brand ILIKE ? OR name ILIKE ? OR partnumber ILIKE ?', search_condition, search_condition, search_condition).order('id')
			@category_results += Category.where('name ILIKE ?', search_condition).order('id')

			# Paginate the results
			@product_results = Kaminari.paginate_array(@product_results).page(params[:product_page]).per(10)
			@part_results = Kaminari.paginate_array(@part_results).page(params[:part_page]).per(5)
			@category_results = Kaminari.paginate_array(@category_results).page(params[:category_page]).per(10)
		end
	end

	def search_model_extended
		# Used in AJAX request to link to the category page of searched products

		id = params[:id]
		brand = params[:brand]
		model = params[:model]
		model_extended = params[:model_extended]

		if !model_extended.blank?
			# Renders the category page of the product with the model_extended that was selected
			product = Product.find_by(device_id: id, brand: brand, model_extended: model_extended)
			render :js => "window.location = '#{device_product_categories_path(product.device_id, product)}'"
		end
	end

	# Method for showing all parts of a certain category
	def all_parts
		# Checks if it can find the flash
  	if flash[:item_added]
  		# Parameters used for the modal _cart_show_modal.html.erb inside parts view
      @cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end

		@reminder = Reminder.new
		@cart_item = CartItem.new
		@all_parts = Part.where(category_id: params[:category_id]).page(params[:page]).per(10).order('id ASC')
	end

 	# Method for showing a certain part page
	def part
		# Checks if it can find the flash
  	if flash[:item_added]
  		# Parameters used for the modal _cart_show_modal.html.erb inside parts view
      @cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
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

	# Method for showing a page that shows all products that a part can be used in 
	def suitable_products
		@part = Part.find(params[:part_id])
		@connections = @part.parts_products.page(params[:page]).per(30)
	end

	# Method for showing a page that shows all invoices
	def invoices
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@invoices = Invoice.all.order('id DESC').page(params[:page]).per(10)
	end

	def options_device
		# Used in AJAX request to fill in #device_select in the header

		# Check which id got sent with the AJAX request
		# params[:id] is the id that gets send from clicking in the dynamic search
		if !params[:id].blank?
	    id = params[:id]

 		  if !id.blank?
		    render :partial => 'options_device'
			end
		# params[:p_id] is params[:product_id] in the url
		elsif !params[:p_id].blank?
			id = params[:p_id]

			# If id isn't blank fill in #device_select
	    if !id.blank?
	    	product = Product.find(id)
	    	@device = Device.find(product.device_id)  
		    render :partial => 'options_device'
			end
		# params[:d_id] is params[:device_id] in the url
		elsif !params[:d_id].blank?
			id = params[:d_id]

			# If id isn't blank fill in #device_select
			if !id.blank?
				@device = Device.find(id)
				render :partial => 'options_device'
			end
		end
	end

	def options_brand
		# Used in AJAX request to fill in #brand_select in the header

		# Check which id got sent with the AJAX request
		# params[:id] is the id that gets send from clicking in the dynamic search
		if !params[:id].blank?
	    id = params[:id]

	    # If id isn't blank fill in #brand_select
	    if !id.blank?
		    @products = Product.where(device_id: id).pluck(:brand).uniq
		    render :partial => 'options_brand'
			end
		# params[:p_id] is params[:product_id] in the url
		elsif !params[:p_id].blank?
			id = params[:p_id]

			# If id isn't blank fill in #brand_select
	    if !id.blank?
	    	@product = Product.find(id)
		    @products = Product.where(device_id: @product.device_id).pluck(:brand).uniq
		    render :partial => 'options_brand'
			end
		# params[:d_id] is params[:device_id] in the url
		elsif !params[:d_id].blank?
			id = params[:d_id]
			
			# If id isn't blank fill in #brand_select
			if !id.blank?
				@brand = params[:brand]
				@products = Product.where(device_id: id).pluck(:brand).uniq
				render :partial => 'options_brand'
			end
		end
	end

	def options_model
		# Used in AJAX request to fill in #model_select in the header

		# Check which id got sent with the AJAX request
		# params[:id] is the id that gets send from clicking in the dynamic search
		if !params[:id].blank?	
			id = params[:id]
			brand = params[:brand]

			# If brand isn't blank fill in #model_select
			if !brand.blank?
				@products = Product.where(device_id: id, brand: brand).pluck(:model).uniq
				render :partial => 'options_model'
			end
		# params[:p_id] is params[:product_id] in the url
		elsif !params[:p_id].blank?
			id = params[:p_id]
			
			# If id isn't blank fill in #model_select
			if !id.blank?
				@product = Product.find(id)
				@products = Product.where(device_id: @product.device_id, brand: @product.brand).pluck(:model).uniq
				render :partial => 'options_model'
			end
		# # params[:d_id] is params[:device_id] in the url
		elsif !params[:d_id].blank?
			id = params[:d_id]

			# If id isn't blank fill in #model_select
			if !id.blank?
				@model = params[:model]
				@products = Product.where(device_id: id, brand: params[:brand]).pluck(:model).uniq
				render :partial => 'options_model'
			end
		end
	end

	def options_model_extended
		# Used in AJAX request to fill in #model_extended_select in the header

		# Check which id got sent with the AJAX request
		# params[:id] is the id that gets send from clicking in the dynamic search
		if !params[:id].blank?
			id = params[:id]
			brand = params[:brand]
			model = params[:model]

			# Checks if the model isn't blank and that the product doesn't have a model_extended
			if !model.blank? && !Product.where(model: model, device_id: id).pluck(:model_extended).any?
				# Renders the category page of the product with the model that was selected
				product = Product.find_by(device_id: id, brand: brand, model: model)
				unless product.blank?
					render :js => "window.location = '#{device_product_categories_path(product.device_id, product)}'"
					return
				end
			end

			# If model isn't blank fill in #model_extended_select
			if !model.blank?
				@products = Product.where(device_id: id, brand: brand, model: model).pluck(:model_extended).uniq
				render :partial => 'options_model_extended'
			end
		# params[:p_id] is params[:product_id] in the url
		elsif !params[:p_id].blank?
			id = params[:p_id]

			if !id.blank?
				@product = Product.find(id)
				@products = Product.where(device_id: @product.device_id, brand: @product.brand, model: @product.model).pluck(:model_extended).uniq
				# If @products doesn't include nil than render a partial to fill in #model_extended_select
				if !@products.include?(nil)
					render :partial => 'options_model_extended'
				else
					render inline: 'No Extended' # Needed for Javascript response
				end
			end
		# params[:d_id] is params[:device_id] in the url
		elsif !params[:d_id].blank?
			id = params[:d_id]

			if !id.blank?
				@products = Product.where(device_id: id, brand: params[:brand], model: params[:model]).pluck(:model_extended).uniq
				# If @products doesn't include nil than render a partial to fill in #model_extended_select
				if !@products.include?(nil)
					render :partial => 'options_model_extended'
				else
					render inline: 'No Extended' # Needed for Javascript response
				end
			end
		end
	end
end

