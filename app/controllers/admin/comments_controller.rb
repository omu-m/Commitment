class Admin::CommentsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @comments = Comment.all
    @comments = @comments.order(created_at: :desc)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
end
