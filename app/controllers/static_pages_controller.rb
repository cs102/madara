class StaticPagesController < ApplicationController

  def home
    @user = User.new
    if logged_in?
  	  @bookmark = current_user.bookmarks.build
  	  @feed_items = current_user.feed.paginate(page: params[:page]).includes(:user)
      @user = current_user
    end
  end

  def help
  end

  def about
  end

  def blog
  end
end
