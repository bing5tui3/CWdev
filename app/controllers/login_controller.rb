class LoginController < ApplicationController
	def show
    if signed_in?
      @user = @current_user
      render 'users/show'
    else
      render 'show'
    end
	end

	def check
    @user = User.find_by_email(params[:login][:email])
    if @user && @user.authenticate(params[:login][:password])
      sign_in @user
      redirect_back_to @user
    else
      flash[:danger] = "User Not Registered"
      render 'show', :login => params[:login]
    end
	end

	def logout
    sign_out
    redirect_to root_path
	end
end
