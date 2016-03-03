class ProductsController < ApplicationController
	helper_method :sort_column, :sort_direction

	def index
    @products = Product.where(device_id: params[:device_id]).page(params[:page]).per(25).order('id')
  end

  def new
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    @product = Product.new
  end

  def create
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    params[:product][:device_id] = params[:device_id]
    
    @product = Product.new(product_params)
    brand = params[:product][:brand]
    brand_select = params[:product][:brand_select]
    model = params[:product][:model]
    model_select = params[:product][:model_select]
    

    render 'new', :alert => "Only choose one brand" and return if (brand.blank? && brand_select.blank?) or (!brand.blank? && !brand_select.blank?)
    @product.brand = brand_select if brand.blank?
    
    render 'new', :alert => "Only choose one model" and return if (model.blank? && model_select.blank?) or (!model.blank? && !model_select.blank?)
    @product.model = model_select if model.blank?

    if @product.save
      redirect_to device_products_path(params[:device_id])
      flash[:success] = "Product added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    @product = Product.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to device_products_path(params[:device_id])
      flash[:success] = "Product updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return   unless current_user.manager?
    product = Product.find(params[:id])
    product.destroy
    redirect_to device_products_path(params[:device_id])
    flash[:success] = "Product deleted"
  end

  private

  def product_params
    params.require(:product).permit(:device_id, :brand, :model, :model_serial, :product)
  end
end
