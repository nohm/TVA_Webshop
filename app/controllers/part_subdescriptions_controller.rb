class PartSubdescriptionsController < ApplicationController
	def index
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @descriptions = PartSubdescription.where(partdescription_id: params[:partdescription_id]).page(params[:page]).per(25)
  end

  def new
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @description = PartSubdescription.new
  end

  def create
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:part_subdescription][:partdescription_id] = params[:partdescription_id]
    @description = PartSubdescription.new(part_subdescription_params)
    if @description.save
      redirect_to device_product_category_part_partdescription_part_subdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id], params[:partdescription_id])
      flash[:success] = "description added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @description = PartSubdescription.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @description = PartSubdescription.find(params[:id])
    if @description.update(part_subdescription_params)
      redirect_to device_product_category_part_partdescription_part_subdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id], params[:partdescription_id])
      flash[:success] = "description updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    description = PartSubdescription.find(params[:id])
    description.destroy
    redirect_to device_product_category_part_partdescription_part_subdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id], params[:partdescription_id])
    flash[:success] = "description deleted"
  end

  private

  def part_subdescription_params
    params.require(:part_subdescription).permit(:partdescription_id, :title, :value)
  end
end
