class PartsController < ApplicationController
  def index
    @parts_products = PartsProduct.where(product_id: params[:product_id]).page(params[:page]).per(25).order('id ASC')
    @parts = Part.where(category_id: params[:category_id])
  end

  def show
    @part = Part.find(params[:id])
    @cart = Cart.new
    @partimages = Partimage.where(part_id: params[:id])
    @partdescriptions = Partdescription.where(part_id: params[:id]).order('title ASC')
  end

  def new
    redirect_to root_path, :alert => "Unauthorized" and return unless current_user.manager?
    @part = Part.new
  end

  def create
    redirect_to root_path, :alert => "Unauthorized" and return unless current_user.manager?
    params[:part][:category_id] = params[:category_id]
    params[:part][:device_id] = params[:device_id]
    params[:part][:price_ex] = params[:part][:price_ex].to_s.gsub(',', '.').to_f
    @part = Part.new(part_params)
    if @part.save
      PartsProduct.create(part_id: @part.id, product_id: params[:product_id])
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return unless current_user.manager?
    @part = Part.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return unless current_user.manager?
    params[:part][:price_ex] = params[:part][:price_ex].to_s.gsub(',', '.').to_f
    @part = Part.find(params[:id])
    if @part.update(part_params)
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return unless current_user.manager?
    part = Part.find(params[:id])
    part.destroy
    redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
    flash[:success] = "Part deleted"
  end

  private

  def part_params
    params.require(:part).permit(:category_id, :name, :condition, :warranty, :price_ex, :stock, :partimagefull, :brand)
  end
end
