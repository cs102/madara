class BookmarksController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    #require 'open-uri'
    #require 'openssl'
    #require 'pismo'
    #doc = Pismo::Document.new(bookmark_params[:link])
    #require 'open-uri'
    #require 'Nokogiri'
    doc = Nokogiri::HTML(open(bookmark_params[:link]))
    
    @bookmark = current_user.bookmarks.build(bookmark_params)
    @bookmark.title = doc.title.to_s
    
    if @bookmark.save
      #flash[:success] = "Bookmark saved"
      redirect_to root_url
    else
      #redirect_to root_url
      @feed_items = [] # this line is need it case of link is empty
      redirect_to root_url
      #render 'static_pages/home'
    end
  end

  def destroy
	  @bookmark.destroy!
	  flash[:success] = "Bookmark deleted"
	  redirect_to request.referrer || root_url
  end

  private

    def bookmark_params
      params.require(:bookmark).permit(:link, :title)
    end

    def correct_user
      @bookmark = current_user.bookmarks.find_by(id: params[:id])
      redirect_to root_url if @bookmark.nil?
    end


end
