class UsersController < ApplicationController
	before_filter :logged_in_user, only: [:edit, :update]
	before_filter :correct_user, only: [:edit, :update]

	# 新建用户显示界面调用的方法
	def new
		@user = User.new
	end

	# 提交创建用户的方法
	def create
		user = { 
			:name                  => params[:user][:name],
			:admin_type            => "2",
			:email                 => params[:user][:email],
			:password              => params[:user][:password],
			:password_confirmation => params[:user][:password_confirmation],
			:icode                 => params[:user][:icode]
		 }
		@user = User.new(user)
		if @user.save
			flash[:success] = "Welcome!"
			sign_in @user
			redirect_back_to @user
		else
		  render 'new'
		end
	end

  # 显示某一个用户
	def show
		@user = User.find(params[:id])
	end

  # 更新用户信息是显示更新页面的方法
	def edit
		@user = User.find(params[:id])
	end

	# 更新用户
	def update
		@user = User.find(params[:id])
		params.permit!
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			if @user.cropping?
				@user.portrait.reprocess!(:medium)
			end
			sign_in @user
			if params[:user][:portrait].present?
				render :crop
			else
				redirect_to @user
			end
		else
			render plain:@user.errors.inspect
		end
	end

	#所有用户显示
	def index
		@users = User.all
	end

	#用户控制面板
	def dashboard
		@user = User.find(params[:id])
	end

	private

	  def logged_in_user
	  	if !signed_in?
	  		store_location
	  		flash[:warning] = "Please Log in First"
	  		redirect_to login_path
	  	end
	  end

	  def correct_user
	  	@user = User.find(params[:id])
	  	redirect_to(root_path) unless current_user?(@user)
	  end

	  # def save_user_portrait(uploaded_io, user_id)
	  # 	folder = "public/users/#{user_id}/portrait"
    #   FileUtils::mkdir_p folder
    #   # f = File.open File.join(folder, filename),'wb'
    #   # f.write portrait.read()
	  # 	File.open(Rails.root.join(folder, uploaded_io.original_filename), 'wb') do |file|
	  # 		file.write(uploaded_io.read)
	  # 	end
	  # end
end
