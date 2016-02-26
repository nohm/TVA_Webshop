class ProductsController < ApplicationController
	def index
    @products = Product.all.page(params[:page]).per(25).order('device ASC')
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    device = params[:product][:device]
    device_select = params[:product][:device_select]
    brand = params[:product][:brand]
    brand_select = params[:product][:brand_select]
    model = params[:product][:model]
    model_select = params[:product][:model_select]

    render 'new', :alert => "Only choose one device" and return if (device.blank? && device_select.blank?) or (!device.blank? && !device_select.blank?)
    @product.device = device_select if device.blank?

    render 'new', :alert => "Only choose one brand" and return if (brand.blank? && brand_select.blank?) or (!brand.blank? && !brand_select.blank?)
    @product.brand = brand_select if brand.blank?
    
    render 'new', :alert => "Only choose one model" and return if (model.blank? && model_select.blank?) or (!model.blank? && !model_select.blank?)
    @product.model = model_select if model.blank?

    if @product.save
      redirect_to products_path
      flash[:success] = "Product added"
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_pat
      flash[:success] = "Product updated"
    else
      render 'edit'
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to products_path
    flash[:success] = "Product deleted"
  end

  private

  def product_params
    params.require(:product).permit(:device, :brand, :model, :model_serial, :product)
  end
end
