crumb :root do
  link "Home", root_path
end

crumb :user do
	link User.find_by(id: params[:id]).name, user_path(current_user.id)
end

crumb :users do
	link "Users", users_path
end 

crumb :carts do
	link "Cart", carts_path
end

crumb :invoices do
	link "Invoices", invoices_path
end

crumb :invoice do
	link "Invoice " + params[:id], invoice_path(params[:id])
	parent :invoices
end 

crumb :devices do
	link "Devices", devices_path
end

crumb :products do
	link "Products", device_products_path(params[:device_id])
	parent :devices
end

crumb :categories do
	link "Categories", device_product_categories_path(params[:device_id], params[:product_id])
	parent :products
end

crumb :parts do
	link "Parts", device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
	parent :categories
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

crumb :search do
	link "Search", :back
end

crumb :all_parts do
	link Category.find_by(id: params[:category_id]).name, parts_path(params[:category_id])
	parent :search
end

crumb :parts_products do
	link "Part connections", device_product_category_part_parts_products_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
	parent :parts
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