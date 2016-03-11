class PartdescriptionsController < ApplicationController
	def index
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partdescriptions = Partdescription.where(part_id: params[:part_id]).page(params[:page]).per(25)
  end

  def new
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partdescription = Partdescription.new
  end

  def create
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:partdescription][:part_id] = params[:part_id]
    @partdescription = Partdescription.new(partdescription_params)
    if @partdescription.save
      redirect_to device_product_category_part_partdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Partdescription added"
    else
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partdescription = Partdescription.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partdescription = Partdescription.find(params[:id])
    if @partdescription.update(partdescription_params)
      redirect_to device_product_category_part_partdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
      flash[:success] = "Partdescription updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
    partdescription = Partdescription.find(params[:id])
    partdescription.destroy
    redirect_to device_product_category_part_partdescriptions_path(params[:device_id], params[:product_id], params[:category_id], params[:part_id])
    flash[:success] = "Partdescription deleted"
  end

  private

  def partdescription_params
    params.require(:partdescription).permit(:part_id, :title, :value)
  end
end
