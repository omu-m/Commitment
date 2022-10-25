class Admin::SubtasksController < ApplicationController

  before_action :authenticate_admin!

  def index
    @task = Task.find(params[:task_id])
    @subtasks = @task.subtasks.all
    @subtasks = @subtasks.order(created_at: :desc)
  end

  def show
    @subtask = Subtask.find(params[:id])
    # order(created_at: :desc)を付与することで、コメントを新着順（降順）で表示することができる。
    @comments = @subtask.comments.order(created_at: :desc)
  end

  def destroy
    subtask = Subtask.find(params[:id])
    subtask.destroy
    redirect_to admin_task_subtasks_path
  end

  private

  def subtask_params
    params.require(:subtask).permit(:subtask_content, :progress_status)
  end
end
