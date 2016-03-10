class CategoriesController < ApplicationController
	def index
    @categories = Category.where(device_id: params[:device_id]).page(params[:page]).per(25).order('id ASC')
  end

	def new
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
		@category = Category.new
	end

	def create
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
		params[:category][:product_id] = params[:product_id]
    params[:category][:device_id] = params[:device_id]

    @category = Category.new(category_params)
    @category.name = @category.product.device.name.titleize + ' ' + @category.name unless @category.name.include?(@category.product.device.name.titleize)
    if @category.save
      redirect_to device_product_categories_path(params[:device_id], params[:product_id])
      flash[:success] = "Category added"
    else
      render 'new'
  	end
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    @category = Category.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    @category = Category.find(params[:id])
    if @category.update(category_params)
      @category.update_attribute(:name,  @category.product.device.name.titleize + ' ' + @category.name) unless @category.name.include?(@category.product.device.name.titleize)
      redirect_to device_product_categories_path(params[:device_id], params[:product_id])
      flash[:success] = "Category updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    category = Category.find(params[:id])
    category.destroy
    redirect_to device_product_categories_path(params[:device_id], params[:product_id])
    flash[:success] = "Category deleted"
  end
  
  private

	def category_params
	  params.require(:category).permit(:product_id, :device_id, :name, :cimg)
	end
end
