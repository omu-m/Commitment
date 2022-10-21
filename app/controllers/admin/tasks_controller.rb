class Admin::TasksController < ApplicationController

  before_action :authenticate_admin!

  def index
    @tasks = Task.all
    @tasks = @tasks.order(created_at: :desc)
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
      flash[:notice] = "親タスクが正常に編集されました。"
      redirect_to admin_tasks_path
    else
      flash[:notice] = "親タスクの編集に失敗しました。"
      render "show"
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
