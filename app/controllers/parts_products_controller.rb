class PartsProductsController < ApplicationController

	def index
	end

	def new
		@part_product = PartsProduct.new
		@parts = Part.all.pluck(:id, :name)
	end

	def create
		@part_product = PartsProduct.new(parts_products_params)
		if @part_product.save
			redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part added" 
		else
			render 'new'
		end
	end

	def destroy
		part_product = PartsProduct.find_by(id: params[:id])
		part_product.destroy
	end

	private

		def parts_products_params
			params.require(:parts_product).permit(:part_id, :product_id)
		end
end
