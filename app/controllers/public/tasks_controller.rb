class Public::TasksController < ApplicationController

  # 親タスクをグループとして作成しています。
  before_action :authenticate_member!
  before_action :ensure_correct_member, only: [:edit, :update]

  def index
    @tasks = Task.all
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.owner_id = current_member.id
    # @task.membersに、current_memberを追加しているという記述。
    @task.members << current_member
    if @task.save
      flash[:notice] = "親タスクが正常に作成されました。"
      redirect_to tasks_path
    else
      flash[:notice] = "親タスクの作成に失敗しました。"
      @tasks = Task.all
      render "index"
    end
  end

  def show
    @task = Task.find(params[:id])
    @tasks = Task.new
  end

  # 参加／退出
  def join
    @task = Task.find(params[:task_id])
    @task.members << current_member
    redirect_to  tasks_path
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "親タスクが正常に編集されました。"
      redirect_to tasks_path
    else
      flash[:notice] = "親タスクの編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    #@task = Task.find(params[:id])
    task_member = TaskMember.find_by(task_id: params[:id], member_id: current_member.id)
    task_member.destroy
    #current_memberは、@task.membersから消されるという記述。
    #@task.members.delete(current_member)
    redirect_to tasks_path
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
