class PartsProductsController < ApplicationController

	def index
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@parts_products = PartsProduct.where(part_id: params[:part_id])
	end

	def new
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_product = PartsProduct.new
		@parts = Part.all.pluck(:id, :name)
	end

	def create
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@part_product = PartsProduct.new
		@model = params[:parts_product][:product_id]
		part_id = Part.find_by(name: params[:parts_product][:part_id]).id
		if !Product.find_by(device_id: params[:device_id], model: @model).nil? && Product.find_by(device_id: params[:device_id], model: @model).model_extended.blank?
			product_id = Product.find_by(device_id: params[:device_id], model: @model).id
		else
			product_id = Product.find_by(device_id: params[:device_id], model_extended: @model).id
		end
		@part_product = PartsProduct.new(part_id: part_id, product_id: product_id)

		if @part_product.save
			redirect_to device_product_category_part_parts_products_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Connection added" 
		else
			render 'new'
		end
	end

	def destroy
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		part_product = PartsProduct.find_by(id: params[:id])
		part_product.destroy
		redirect_to device_product_category_part_parts_products_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id], part_product)
    flash[:success] = "Connection deleted"
	end

	def connect_brand
    id = params[:id]

    # Fill in #brand_select
    if !id.blank?
	    @product = Product.where(device_id: id).pluck(:brand).uniq
	    render :partial => 'connect_brand'
		end
	end

	def connect_model
		id = params[:id]
		brand = params[:brand]

		# Fill in #model_select
		if !brand.blank?
			@product = Product.where(device_id: id, brand: brand).pluck(:model).uniq
			render :partial => 'connect_model'
		end
	end

	def connect_model_extended
		id = params[:id]
		brand = params[:brand]
		model = params[:model]
		@part_product = PartsProduct.new

		if !model.blank? && !Product.where(model: model, device_id: id).pluck(:model_extended).any?
			@product_id = Product.find_by(device_id: id, brand: brand, model: model)
			unless @product_id.blank?
 				render inline: 'No model_extended' # Needed for Javascript response
			end
		else
			@product = Product.where(device_id: id, brand: brand, model: model).pluck(:model_extended)
			render :partial => 'connect_model_extended'
		end
	end

	private

		def parts_products_params
			params.require(:parts_product).permit(:part_id, :product_id)
		end
end
