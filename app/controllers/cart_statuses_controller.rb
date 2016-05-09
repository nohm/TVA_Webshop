class CartStatusesController < ApplicationController
	def index
		@statuses = CartStatus.all.page(params[:page]).per(10)
	end

	def new
		@status = CartStatus.new
	end

	def create
		@status = CartStatus.new(cart_status_params)
    if @status.save
      redirect_to cart_statuses_path
      flash[:success] = "Status added"
    else
    	render 'new'
    end
	end

	def edit
		@status = CartStatus.find(params[:id])
	end

	def update
		@status = CartStatus.find(params[:id])
    if @status.update(cart_status_params)
      redirect_to cart_statuses_path
      flash[:success] = "Status updated"
    else
      render 'edit'
    end
	end

	def destroy
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
