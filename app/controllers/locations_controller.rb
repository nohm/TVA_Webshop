class LocationsController < ApplicationController
	def index
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@locations = Location.all.page(params[:page]).per(25).order('id ASC')
	end

	def new
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@location = Location.new
	end

	def create
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@location = Location.new(location_params)
		if @location.save
      redirect_to locations_path
      flash[:success] = "Location added"
    else
      render 'new'
  	end
	end

	def edit
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@location = Location.find(params[:id])
	end

	def update
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		@location = Location.find(params[:id])
    if @location.update(location_params)
      redirect_to locations_path
      flash[:success] = "Location updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.manager?
		location = Location.find(params[:id])
		location.destroy
		redirect_to locations_path
		flash[:success] = "Location deleted"
	end

	private

	def location_params
		params.require(:location).permit(:name, :street, :city, :postal_code, :country, :phone_number)
	end
end
