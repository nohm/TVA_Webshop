class CartStatusesController < ApplicationController
	def index
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@statuses = CartStatus.all.page(params[:page]).per(10)
	end

	def new
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@status = CartStatus.new
	end

	def create
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@status = CartStatus.new(cart_status_params)
    if @status.save
      redirect_to cart_statuses_path
      flash[:success] = "Status added"
    else
    	render 'new'
    end
	end

	def edit
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@status = CartStatus.find(params[:id])
	end

	def update
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@status = CartStatus.find(params[:id])
    if @status.update(cart_status_params)
      redirect_to cart_statuses_path
      flash[:success] = "Status updated"
    else
      render 'edit'
    end
	end

	def destroy
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		status = CartStatus.find(params[:id])
    status.destroy
    redirect_to cart_statuses_path
    flash[:success] = "Status deleted"
	end

	private

  def cart_status_params
    params.require(:cart_status).permit(:name)
  end
end
