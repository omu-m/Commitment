class Public::TasksController < ApplicationController

  # 親タスクをグループとして作成しています。
  before_action :authenticate_member!
  before_action :authenticate_user, only: [:create, :update, :destroy, :all_destroy]
  before_action :ensure_correct_member, only: [:edit, :update]

  def index
    subtask_id = Subtask.order(updated_at: :desc).pluck(:task_id).uniq
    if params[:member_id].present?
      @tasks_id = TaskMember.where(member_id: params[:member_id]).pluck(:task_id)
      @tasks = Task.where(id: @tasks_id).page(params[:page])
    else
      @tasks = Task.page(params[:page])
    end
    @task = Task.new
    @tasks = @tasks.order_as_specified(id: subtask_id)
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
      @tasks = Task.page(params[:page])
      render "index"
    end
  end

  def show
    @task = Task.find(params[:id])
    @tasknew = Task.new
    @task_member = @task.task_members.find_by(member: current_member)
    @status = @task_member.present? ? @task_member.approval_status_before_type_cast : 0
    @current_status = @task_member.present? ? @task_member.approval_status_i18n : "参加前"
  end

  # 参加
  # def join
  #   @task = Task.find(params[:task_id])
  #   @task.members << current_member
  #   redirect_to  task_path(@task)
  # end

  # 退出
  def out
    @task = Task.find(params[:task_id])
    @task.members.delete(current_member)
    redirect_to  tasks_path
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])
    if nil != (params[:task][:owner_id] =~ /\A[0-9]+\z/)
      @task.owner_id = params[:task][:owner_id]
    end
    if @task.update(task_params)
      flash[:notice] = "親タスクが正常に編集されました。"
      redirect_to tasks_path
    else
      flash[:notice] = "親タスクの編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    # @task = Task.find(params[:id])
    task_member = TaskMember.find_by(task_id: params[:id], member_id: current_member.id)
    task_member.destroy
    # # current_memberは、@task.membersから消されるという記述。
    # @task.members.delete(current_member)
    redirect_to tasks_path
  end

  def all_destroy
    @task = Task.find(params[:task_id])
    if @task.destroy
    redirect_to tasks_path
    end
  end

  def request_join
    # ログイン中のユーザーが、特定のタスクに参加申請を行う
    task_member =  TaskMember.find_by(task_id: params[:task_id], member_id: current_member.id)
    if task_member.present?
      if task_member.approval_status == 3 || 4
        TaskMember.find_by(task_id: params[:task_id], member_id: current_member.id).update(approval_status: 1)
      end
    else
      TaskMember.create(task_id: params[:task_id], member_id: current_member.id, approval_status: 1)
    end

    # タスク詳細ページに戻る
    @task = Task.find(params[:task_id])
    @task.members << current_member
    redirect_to  task_path(@task)
  end

  def request_join_destroy
    TaskMember.find_by(task_id: params[:task_id], member_id: current_member.id).update(approval_status: 4)

    # タスク詳細ページに戻る
    @task = Task.find(params[:task_id])
    @task.members << current_member
    redirect_to  task_path(@task)
  end

  def applies
    @task = Task.find(params[:task_id])
    @task_members = @task.task_members.where(approval_status: 1)
  end

  def approval_request
    # オーナーがログイン中のユーザーが、特定のタスクに参加する承認を行う
    TaskMember.find_by(task_id: params[:task_id], member_id: params[:member_id]).update(approval_status: 2)
    redirect_to task_applies_path(params[:task_id])
  end

  def non_approval_request
    # オーナーがログイン中のユーザーが、特定のタスクに参加する非承認を行う
    TaskMember.find_by(task_id: params[:task_id], member_id: params[:member_id]).update(approval_status: 3)
    redirect_to task_applies_path(params[:task_id])
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
