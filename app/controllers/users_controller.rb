class UsersController < ApplicationController

  def index
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.admin?
    @users = User.all.page(params[:page]).per(25).order('id ASC')
  end

  def show
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.id == params[:id].to_i || logged_in? && current_user.admin?
    @user = User.find(params[:id])
    @invoices = Invoice.where(user_id: @user.id).page(params[:page]).per(20)
  end

  def new
    @user = User.new
  end

  def edit
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.id == params[:id].to_i
    @user = User.find(params[:id])
  end

  def update
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.id == params[:id].to_i || logged_in? && current_user.admin?
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path
      flash[:success] = "Settings updated"
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    @user.role_id = 3
    if @user.save
      log_in @user
      Cart.create(user_id: @user.id)
      flash[:success] = "Welcome to the Webshop!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.admin?
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path
    flash[:success] = "User deleted"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :street, :city, :province, :country, :postal_code, :phone_number, :password, :password_confirmation, :role_id)
    end
end
