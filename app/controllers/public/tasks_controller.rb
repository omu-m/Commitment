class Public::TasksController < ApplicationController

  def index
    @tasks = Task.all
    @task = Task.new
    @member = current_member
  end

  def create
    @task = Task.new(task_params)
    # @task.member_id = current_member.id
    if @task.save
      redirect_to task_path(@task)
      flash[:notice] = "親タスクが正常に作成されました。"
    else
      @tasks = Task.all
      @member = current_member
      render "index"
    end
  end

  def show
  end

  def edit
  end

  private

  def task_params
    params.require(:task).permit(:task_title, :task)
  end
end
