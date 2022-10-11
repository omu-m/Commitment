class Public::TasksController < ApplicationController

  before_action :authenticate_member!
  before_action :ensure_correct_member, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.owner_id = current_member.id
    if @task.save
      flash[:notice] = "親タスクが正常に作成されました。"
      redirect_to tasks_path
    else
      flash[:notice] = "親タスクの作成に失敗しました。"
      redirect_to task_path
    end
  end

  def show
    @task = Task.find(params[:id])
    @tasks = Task.new
  end

  def edit
  end

  private

  def task_params
    params.require(:task).permit(:task_title, :task_content, :image)
  end

  def ensure_correct_member
    @task = Task.find(params[:id])
    unless @task.owner_id == current_member.id
      redirect_to task_path
    end
  end
end
