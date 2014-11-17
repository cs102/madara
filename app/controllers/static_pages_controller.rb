class StaticPagesController < ApplicationController
  def home
    if logged_in?
  	  @bookmark = current_user.bookmarks.build
  	  @feed_items = current_user.feed.paginate(page: params[:page]) 
      @user = current_user
      @current_time = Time.now
    end
  end

  def help
  end

  def about
  end

  def blog
  end
end
