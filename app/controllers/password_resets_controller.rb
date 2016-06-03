class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      Mailer.send_password_reset(@user).deliver_now
      flash[:info] = "An email has been sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:notice] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks if a reset has expired
    def check_expiration
    	if @user.password_reset_expired?
    		flash[:notice] = "Password reset has expired"
    		redirect_to new_password_reset_url
    	end
    end
end
