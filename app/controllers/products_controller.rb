class ProductsController < ApplicationController
	def index
    if logged_in? && current_user.role.name != "Client"
      @products = Product.where(device_id: params[:device_id]).page(params[:page]).per(25).order('id')
    else
      device_id = params[:device_id]
      brand = params[:brand]
      model = params[:model]
      if !device_id.nil? && !brand.nil? && !model.nil?
        @products = Product.where(device_id: device_id, brand: brand, model: model).select([:device_id, :model, :brand, :model_extended]).group(:device_id, :model, :brand, :model_extended)
      elsif !device_id.nil? && !brand.nil?
        @products = Product.where(device_id: device_id, brand: brand).select([:device_id, :model, :brand]).group(:device_id, :model, :brand)
      elsif !device_id.nil? 
        @products = Product.where(device_id: device_id).select([:device_id, :brand]).group(:device_id, :brand)
      end
    end
  end

  def new
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @product = Product.new
  end

  def create
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:product][:device_id] = params[:device_id]
    @product = Product.new(product_params)
    brand = params[:product][:brand]
    brand_select = params[:product][:brand_select]

    if (brand.blank? && brand_select.blank?) || (!brand.blank? && !brand_select.blank?)
      flash[:half_notice] = "Choose one brand"
      render 'new' and return
    end

    @product.brand = brand_select if brand.blank?

    if @product.save
      redirect_to device_products_path(params[:device_id])
      flash[:success] = "Product added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @product = Product.find(params[:id])
  end

  def update
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:product][:device_id] = params[:device_id]
    @product = Product.find(params[:id])
    brand = params[:product][:brand]
    brand_select = params[:product][:brand_select]

    if (brand.blank? && brand_select.blank?) || (!brand.blank? && !brand_select.blank?)
      flash[:half_notice] = "Choose one brand"
      render 'edit' and return
    end

    @product.brand = brand_select if brand.blank?

    if @product.update(product_params)
      redirect_to device_products_path(params[:device_id])
      flash[:success] = "Product updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    product = Product.find(params[:id])
    product.destroy
    redirect_to device_products_path(params[:device_id])
    flash[:success] = "Product deleted"
  end

  private

  def product_params
    params.require(:product).permit(:device_id, :brand, :model, :model_extended)
  end
end
