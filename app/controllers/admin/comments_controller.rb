class Admin::CommentsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @comments = Comment.all
    @comments = @comments.order(created_at: :desc)
  end

  def destroy
    @subtask = Subtask.find(params[:subtask_id])
    @comments = @subtask.comments.order(created_at: :desc)
    comment = Comment.find(params[:id])
    comment.destroy
    render "index"
  end
end
