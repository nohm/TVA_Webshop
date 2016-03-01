class DevicesController < ApplicationController
	def index
		@device = Device.order('id').all.page(params[:page]).per(25)
	end

	def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      redirect_to devices_path
      flash[:success] = "Device added"
    else
    	render 'new'
    end
  end

  def destroy
    device = Device.find(params[:id])
    device.destroy
    redirect_to devices_path
    flash[:success] = "Device deleted"
  end

  def edit
    @device = Device.find(params[:id])
  end

  def update
    @device = Device.find(params[:id])
    if @device.update(device_params)
      redirect_to devices_path
      flash[:success] = "Device updated"
    else
      render 'edit'
    end
  end

  private

  def device_params
    params.require(:device).permit(:name)
  end
end
