class Admin::TasksController < ApplicationController

  before_action :authenticate_admin!

  def index
    subtask_id = Subtask.order(updated_at: :desc).pluck(:task_id).uniq
    if params[:member_id].present?
      @tasks_id = TaskMember.where(member_id: params[:member_id]).pluck(:task_id)
      @tasks = Task.where(id: @tasks_id).page(params[:page])
    else
      @tasks = Task.page(params[:page])
    end
    @tasks = @tasks.order_as_specified(id: subtask_id)
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = "タスクが正常に編集されました。"
      redirect_to admin_tasks_path
    else
      flash[:notice] = "タスクの編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to admin_tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:task_title, :task_content, :image)
  end
end
