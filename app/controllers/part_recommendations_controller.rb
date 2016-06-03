class PartRecommendationsController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@partrecommendations = PartRecommendation.all.page(params[:page]).per(10)
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
		@partrecommendation = PartRecommendation.new()
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partrecommendation = PartRecommendation.new(partrecommendation_params)
    if PartRecommendation.where(part_id: params[:part_recommendation][:part_id]).blank?
	    if @partrecommendation.save
	      redirect_to request.referrer
	      flash[:success] = "Recommendation added"
	    else
	      render 'new'
	    end
	  else
	  	redirect_to request.referrer
	  	flash[:notice] = "Product is already in the recommended list"
	  end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partrecommendation = PartRecommendation.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @partrecommendation = PartRecommendation.find(params[:id])
    if @partrecommendation.update(partrecommendation_params)
      redirect_to request.referrer
      flash[:success] = "Recommendation updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    partrecommendation = PartRecommendation.find(params[:id])
    partrecommendation.destroy
    redirect_to request.referrer
    flash[:success] = "Recommendation deleted"
	end

	private

	def partrecommendation_params
		params.require(:part_recommendation).permit(:part_id)
	end
end
