class Public::SubtasksController < ApplicationController

  before_action :authenticate_member!

  def index
    @task = Task.find(params[:task_id])
    @subtasks = Subtask.all
    @subtask = Subtask.new
  end

  def create
    @subtask = Subtask.new(subtask_params)
    @subtask.task_id = params[:task_id]
    @subtask.member_id = current_member.id
    if @subtask.save
      flash[:notice] = "子タスクが正常に投稿されました。"
      redirect_to task_subtasks_path
    else
      flash[:notice] = "子タスクの投稿に失敗しました。"
      @subtasks = Subtask.all
      render "index"
    end
  end

  def show
  end

  def edit
  end
  

  private

  def subtask_params
    params.require(:subtask).permit(:subtask_content)
  end
end
