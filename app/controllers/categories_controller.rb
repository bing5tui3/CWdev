class CategoriesController < ApplicationController
  before_filter :logged_in_user
  before_filter :admin_user

  def new
    @category = Category.new
  end

  def create
    @category = Category.find_by(:name => params[:category][:name])
    if !@category.nil?
      flash[:warning] = "Category name has existed"
      render 'new'
    else
      @category = Category.new(category_params)
      if @category.save!
        redirect_to categories_path
      else
        flash[:warning] = "Did not save properly due to unknown errors!"
        render 'new'
      end
    end
  end

  def index
    @categories = Category.all.paginate(:page => params[:page]).order('created_at DESC')
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      redirect_to categories_path
    else
      flash[:warning] = "Category name update failed due to unknown errors!"
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def logged_in_user
    if !signed_in?
      store_location
      flash[:warning] = "Please Log in First"
      redirect_to login_path
    end
  end

  def admin_user
    @user = User.find(current_user.id)
    if @user.admin_type != '2'
      redirect_to(root_path)
    end
  end

end
