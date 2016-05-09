class SublocationsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@sublocations = Sublocation.where(location_id: params[:location_id]).page(params[:page]).per(10).order('name ASC')
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@sublocation = Sublocation.new()
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @sublocation = Sublocation.new(sublocation_params)
    if @sublocation.save
      redirect_to location_sublocations_path(params[:location_id])
      flash[:success] = "Sublocation added"
    else
      render 'new'
    end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @sublocation = Sublocation.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @sublocation = Sublocation.find(params[:id])
    if @sublocation.update(sublocation_params)
      redirect_to location_sublocations_path(params[:location_id])
      flash[:success] = "Sublocation updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    sublocation = Sublocation.find(params[:id])
    sublocation.destroy
    redirect_to location_sublocations_path(params[:location_id])
    flash[:success] = "Sublocation deleted"
	end

	private

	def sublocation_params
		params.require(:sublocation).permit(:name, :location_id)
	end
end
