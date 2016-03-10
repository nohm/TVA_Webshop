class HomeController < ApplicationController

	def search
		@query = params[:search_query]
		search_condition = '%' + @query + '%'

		@product_results = []
		@part_results = []
		@category_results = []
		
		if !@query.match(/([a-zA-Z0-9])+/).nil?
			# Devices
			#device = Device.find_by(name: @query) 
			#unless device.blank?
			#	redirect_to device_products_path(device)
			#	return
			#end

			@product_results += Product.where('brand ILIKE ? OR type_number ILIKE ? OR partnumber ILIKE ? OR model_extended ILIKE ?', search_condition, search_condition, search_condition, search_condition)
			@part_results += Part.where('brand ILIKE ? OR name ILIKE ?', search_condition, search_condition)
			@category_results += Category.where('name ILIKE ?', search_condition)
		end
	end
end
