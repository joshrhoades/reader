class CommentsController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  def create
    return unless params[:comment][:body]
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    result = @comment.save
    render "show"
  end

  def index
    @comments = Comment.all
    render :layout => nil
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def destroy
    return if anonymous_user
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      render :json => {:success => @comment.destroy}
    end
  end

  def update
    return if anonymous_user
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      if @comment.update_attributes(params[:comment])
        render "show", :formats => [:json]
      end

    end
  end

  def editor
    return if anonymous_user
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      render "comments/edit_in_place", :layout => nil
    end
  end
end