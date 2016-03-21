class HomeController < ApplicationController

	def search
		@query = params[:search_query]
		search_condition = '%' + @query + '%'


		product_results = []
		part_results = []
		category_results = []
		@product_results = []
		@part_results = []
		@category_results = []
		
		if !@query.match(/([a-zA-Z0-9])+/).blank?
			product_results += Product.where('brand ILIKE ? OR type_number ILIKE ? OR partnumber ILIKE ? OR model ILIKE ? OR model_extended ILIKE ?', search_condition, search_condition, search_condition, search_condition, search_condition)
			part_results += Part.where('brand ILIKE ? OR name ILIKE ?', search_condition, search_condition)
			category_results += Category.where('name ILIKE ?', search_condition)

			@product_results = Kaminari.paginate_array(product_results).page(params[:product_page]).per(10)
			@part_results = Kaminari.paginate_array(part_results).page(params[:part_page]).per(5)
			@category_results = Kaminari.paginate_array(category_results).page(params[:category_page]).per(5)
		end
	end

	def search_model_extended
		id = params[:id]
		brand = params[:brand]
		model_extended = params[:model_extended]

		# Products search through model_extended
		if !model_extended.blank?
			product = Product.find_by(device_id: id, brand: brand, model_extended: model_extended)
				render :js => "window.location = '#{device_product_categories_path(product.device_id, product)}'"
		end
	end

	def all_parts
		@all_parts = Part.where(category_id: params[:category_id]).page(params[:page]).per(20).order('id ASC')
	end

	def options_brand
    id = params[:id]

    # Fill in #brand_select
    if !id.blank?
	    @product = Product.where(device_id: id).pluck(:brand).uniq
	    render :partial => 'options_brand'
		end
	end

	def options_model
		id = params[:id]
		brand = params[:brand]

		# Fill in #model_select
		if !brand.blank?
			@product = Product.where(device_id: id, brand: brand).pluck(:model).uniq
			render :partial => 'options_model'
		end
	end

	def options_model_extended
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
			@product = Product.where(device_id: id, brand: brand, model: model).pluck(:model_extended).uniq
			render :partial => 'options_model_extended'
		end
	end
end

