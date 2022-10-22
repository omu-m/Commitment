class Public::SubtasksController < ApplicationController

  before_action :authenticate_member!
  before_action :ensure_correct_member, only: [:edit, :update]

  def index
    @task = Task.find(params[:task_id])
    @subtasks = @task.subtasks.all
    @subtask = Subtask.new
    @subtasks = @subtasks.order(created_at: :desc)
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
      @task = Task.find(params[:task_id])
      @subtasks = Subtask.all
      render "index"
    end
  end

  def search
    @task = Task.find(params[:task_id])
    @subtasks = @task.subtasks.search(params[:keyword])
    @keyword = params[:keyword]
    @subtask = Subtask.new
    render "index"
  end

  def show
    @subtask = Subtask.find(params[:id])
    # order(created_at: :desc)を付与することで、コメントを新着順（降順）で表示することができる。
    @comments = @subtask.comments.order(created_at: :desc)

  end

  def edit
  end

  def update
    if @subtask.update(subtask_params)
      flash[:notice] = "子タスクが正常に編集されました。"
      redirect_to task_subtasks_path(@subtask.task_id)
    else
      flash[:notice] = "子タスクの編集に失敗しました。"
      render "show"
    end
  end

  def destroy
    @subtask = Subtask.find(params[:id])
    @subtask.destroy
    redirect_to task_subtasks_path
  end

  private

  def subtask_params
    params.require(:subtask).permit(:subtask_content, :progress_status)
  end

  def ensure_correct_member
    @task = Task.find(params[:task_id])
    @subtask = Subtask.find(params[:id])
    unless @subtask.member == current_member
      redirect_to task_subtask_path
    end
  end
end
