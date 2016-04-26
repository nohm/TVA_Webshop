class PartimagesController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@partimages = Partimage.where(part_id: params[:part_id]).page(params[:page]).per(10).order('id ASC')
	end
	
	def new
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partimage = Partimage.new
  end

  def create
    redirect_to new_device_product_category_part_partimage_path and return if params[:partimage].nil?
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:partimage][:part_id] = params[:part_id]
    @partimage = Partimage.new(partimage_params)
    if @partimage.save
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part image added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partimage = Partimage.find(params[:id])
  end

  def update
    redirect_to edit_device_product_category_part_partimage_path and return if params[:partimage].nil?
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partimage = Partimage.find(params[:id])
    if @partimage.update(partimage_params)
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Partdescription updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    partimage = Partimage.find(params[:id])
    partimage.destroy
    redirect_to device_product_category_part_partimages_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
    flash[:success] = "Part deleted"
  end

  private

  def partimage_params
		params.require(:partimage).permit(:part_id, :pimg)
	end
end
