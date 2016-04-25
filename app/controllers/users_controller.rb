class UsersController < ApplicationController

  def index
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.admin?
    @users = User.all.page(params[:page]).per(25).order('id ASC')
  end

  def show
    redirect_to root_path, :alert => "Unauthorized" and return unless logged_in? && current_user.id == params[:id].to_i || logged_in? && current_user.admin?
    @user = User.find(params[:id])
    @invoices = Invoice.where(user_id: @user.id).page(params[:page]).per(20)
    @country = ISO3166::Country[@user.country]
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
      Mailer.send_account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
      params.require(:user).permit(:name, :email, :street, :city, :country, :postal_code, :phone_number, :password, :password_confirmation, :role_id, :current_password)
    end
end
