class CartStatusesController < ApplicationController
	# Method for searching an order by their id or searching orders based on a user's name
	def search_order
		cart = Cart.find_by(id: params[:cart_query])
		user = User.find_by('lower(name) = ?', params[:cart_query])

		if !cart.blank?
			redirect_to cart_status_deliveries_path(cart.cart_status_id, cart: cart.id)
		elsif !user.blank?
			redirect_to cart_statuses_path(user: user.id)
		elsif cart.blank? && user.blank?
			redirect_to cart_statuses_path
			flash[:notice] = "Couldn't find any orders"
		end
	end

	def show
		redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.admin?
		@status = CartStatus.find(params[:id])
		if params[:user].blank?
			@carts = Cart.where(cart_status_id: @status.id).order("id DESC")
		else
			@carts = Cart.where(cart_status_id: @status.id, user_id: params[:user]).order("id DESC")
		end
	end

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
