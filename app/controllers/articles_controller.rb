class ArticlesController < ApplicationController
  before_filter :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :index, :destroy]

  def new
    @user = User.find(params[:user_id])
    @article = Article.new
  end

  def create
    article = {
      :title   => params[:article][:title],
      :content => params[:article][:content],
      :user_id => params[:user_id]
    }
    
    @article = Article.new(article)
    @user    = User.find(params[:user_id])
    if @article.save
      flash[:success] = "New article created!"
      redirect_to user_articles_path
    else
      render plain: params.inspect
    end
  end

  def index
    @articles = Article.where(:user_id => params[:user_id]).paginate(:page => params[:page]).order('created_at DESC')
  end

  def show
    @user    = User.find(params[:user_id])
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      redirect_to user_article_path
    else
      render plain: params.inspect
    end
  end

  def edit
    @user    = User.find(params[:user_id])
    @article = Article.find(params[:id])
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      redirect_to user_articles_path
    else
      render plain: params.inspect
    end
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
      @user = User.find(params[:user_id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def article_params
      params.require(:article).permit(:title, :content)
    end
end
