class CategoriesController < ApplicationController
	def index
    @categories = Category.where(product_id: params[:product_id]).page(params[:page]).per(25).order('product_id ASC')
  end

	def new
    redirect_to root_path, :alert => "Unauthorized"   unless current_user.manager?
		@category = Category.new
	end

	def create
    redirect_to root_path, :alert => "Unauthorized"   unless current_user.manager?
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
    redirect_to root_path, :alert => "Unauthorized"   unless current_user.manager?
    category = Category.find(params[:id])
    category.destroy
    redirect_to device_product_categories_path(params[:device_id], params[:product_id])
    flash[:success] = "Category deleted"
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized"   unless current_user.manager?
    @category = Category.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized"   unless current_user.manager?
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
	  params.require(:category).permit(:product_id, :name, :cimg)
	end
end
