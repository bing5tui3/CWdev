class WelcomeController < ApplicationController
	def show
    @jumbotron = true
    @articles = Article.first(3)
	end
end
