class CategoriesController < ApplicationController
	def index
    @categories = Category.where(product_id: params[:product_id]).page(params[:page]).per(25).order('product_id ASC')
  end

	def new
		@category = Category.new
	end

	def create
		params[:category][:product_id] = params[:product_id]

    @category = Category.new(category_params)
    if @category.save
      redirect_to device_product_categories_path(params[:device_id], params[:product_id])
      flash[:success] = "Category added"
    else
      render 'new'
  	end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to device_product_categories_path(params[:device_id], params[:product_id])
    flash[:success] = "Category deleted"
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to device_product_categories_path(params[:device_id], params[:product_id])
      flash[:success] = "Category updated"
    else
      render 'edit'
    end
  end
  
  private

	def category_params
	  params.require(:category).permit(:product_id, :name)
	end
end
