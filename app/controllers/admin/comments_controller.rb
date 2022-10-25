class Admin::CommentsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @comments = Comment.all
    @comments = @comments.order(created_at: :desc)
  end

  def destroy
    @task = Task.find(params[:task_id])
    @subtask = Subtask.find(params[:subtask_id])
    @comments = @subtask.comments.order(created_at: :desc)
    comment = Comment.find(params[:id])
    comment.destroy
    if params[:comment_index].present?
      redirect_to admin_comments_index_path
    else
      redirect_to admin_task_subtask_path(task_id: @task.id, id: @subtask)
    end
  end
end
