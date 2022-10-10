class Public::TasksController < ApplicationController

  def index
    @tasks = Task.all
    @task = Task.new
    @member = current_member
  end

  def create
    @task = Task.new(task_params)
    @tasks = current_member.id
    if @task.save
      flash[:notice] = "親タスクが正常に作成されました。"
      redirect_to task_path(@task)
    else
      flash[:notice] = "親タスクの作成に失敗しました。"
      @tasks = current_member.tasks.all
      redirect_to task_path
    end
  end

  def show
  end

  def edit
  end

  private

  def task_params
    params.require(:task).permit(:task_title, :task_content)
  end
end
