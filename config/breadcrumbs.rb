crumb :root do
  link "Home", root_path
end

crumb :user do
	link User.find_by(id: params[:user_id] || params[:id]).name, user_path(current_user.id)
end

crumb :users do
	link "Users", users_path
end 

crumb :carts do
	link "Cart", user_carts_path(current_user)
end

crumb :invoices do
	link "Invoices", invoices_path
end

crumb :invoice do
	link "Invoice " + params[:id], user_invoice_path(params[:user_id], params[:id])
	parent :user
end 

crumb :devices do
	if !params[:device_id].blank?
		link Device.find(params[:device_id]).name.titleize, devices_path
	else	
		link "Devices", devices_path
	end
end

crumb :product_brand do
	if !params[:brand].blank?
		link params[:brand], device_products_path(params[:device_id])
	elsif !params[:product_id].blank?
		product = Product.find(params[:product_id])
		link product.brand, device_products_path(params[:device_id])
	else
		link "Brand", device_products_path(params[:device_id])
	end
	parent :devices
end

crumb :product_model do
	if !params[:model].blank?
		link params[:model], device_products_path(params[:device_id], brand: params[:brand])
	elsif !params[:product_id].blank?
		product = Product.find(params[:product_id])
		link product.model, device_products_path(params[:device_id], brand: product.brand)
	else 
		link "Model", device_products_path(params[:device_id])
	end
	parent :product_brand
end

crumb :product_model_extended do
	if !params[:product_id].blank?
		product = Product.find(params[:product_id])
		link product.model_extended, device_products_path(params[:device_id], brand: product.brand, model: product.model)
	else 
		link "Model", device_products_path(params[:device_id])
	end
	parent :product_model
end

crumb :products do
	if !params[:product_id].blank?
		product = Product.find(params[:product_id])
		if !product.model_extended.blank?
			link product.model_extended, device_products_path(params[:device_id])
		else
			link product.model, device_products_path(params[:device_id])
		end
	else
		link "Products", device_products_path(params[:device_id])
	end
	parent :devices
end

crumb :categories do
	if !params[:category_id].blank?
		link Category.find(params[:category_id]).name, device_product_categories_path(params[:device_id], params[:product_id])
	else
		link "Categories", device_product_categories_path(params[:device_id], params[:product_id])
	end

	product = Product.find(params[:product_id])
	if logged_in? && current_user.role.name != "Client"
		parent :products
	elsif !product.model_extended.blank?
		parent :product_model_extended
	else 
		parent :product_model
	end
end

crumb :parts do
	link "Parts", device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
	parent :categories
end

crumb :part_stocks do
	link "Part stocks",device_product_category_part_part_stocks_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
end

crumb :partshow do
	link Part.find_by(id: params[:id]).name, device_product_category_part_path(params[:device_id], params[:product_id], params[:category_id], params[:id])
	parent :parts
end

crumb :partimages do
	link "Part images", device_product_category_part_partimages_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
end

crumb :partdescriptions do
	link "Part descriptions", device_product_category_part_partdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
end

crumb :subdescriptions do
	link "Descriptions", device_product_category_part_partdescription_part_subdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id], params[:partdescription_id])
	parent :partdescriptions
end

crumb :discount_prices do
	link "Discount prices", device_product_category_part_discount_prices_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
end

crumb :search do
	link "Search", search_path(:part_page => params[:part_page], :category_page => params[:category_page], :search_query => params[:search_query])
end

crumb :all_parts do
	link Category.find_by(id: params[:category_id]).blank? ? "Parts" : Category.find_by(id: params[:category_id]).name, parts_path(params[:category_id])
	parent :search
end

crumb :part do
	link Part.find(params[:part_id]).name
	parent :search
end

crumb :parts_products do
	link "Part connections", device_product_category_part_parts_products_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
end

crumb :coupons do
	link "Coupons", coupons_path
end

crumb :locations do
	link "Locations", locations_path
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).