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
    if @task.save
      @task.task_members.create(member_id: current_member.id, approval_status: 2)
      flash[:notice] = "タスクが正常に作成されました。"
      redirect_to tasks_path
    else
      flash[:alert] = "タスクの作成に失敗しました。"
      @tasks = Task.page(params[:page])
      render "index"
    end
  end

  def search
    @tasks = Task.search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    @task = Task.new
    render "index"
  end

  def sort_tasks
    @task = Task.new
    if params[:new]
      @tasks = Task.all.order(created_at: "DESC").page(params[:page])
    elsif params[:old]
      @tasks = Task.all.order(created_at: "ASC").page(params[:page])
    end
    render "index"
  end

  def show
    @task = Task.find(params[:id])
    @tasknew = Task.new
    # 条件を指定して初めの1件を取得し1件もなければ作成
    @task_member = @task.task_members.find_or_initialize_by(member: current_member)
    # @approval_status = @task_member.present? ? @task_member.approval_status : "before_participation"
    # @current_approval_status = @task_member.present? ? @task_member.approval_status_i18n : "参加前"
  end

  # 参加
  # def join
  #   @task = Task.find(params[:task_id])
  #   @task.members << current_member
  #   redirect_to  task_path(@task)
  # end

  # 退出
  def out
    @task = Task.find(params[:id])
    @task.members.delete(current_member)
    redirect_to  tasks_path
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])
    if nil != (params[:task][:owner_id] =~ /\A[0-9]+\z/)
      @task.owner_id = params[:task][:owner_id]
      # 通知
      @task.create_activities(@task, "change_owner", current_member.id, @task.owner_id)
    end
    if @task.update(task_params)
      flash[:notice] = "タスクが正常に編集されました。"
      redirect_to task_path
    else
      flash[:alert] = "タスクの編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    # @task = Task.find(params[:id])
    task_member = current_member.task_members.find_by(task_id: params[:id])
    task_member.destroy
    # # current_memberは、@task.membersから消されるという記述。
    # @task.members.delete(current_member)
    redirect_to tasks_path
  end

  def destroy_all
    @task = Task.find(params[:id])
    if @task.destroy
    redirect_to tasks_path
    end
  end

  def request_join
    task = Task.find(params[:id])
    # ログイン中のユーザーが、特定のタスクに参加申請を行う
    task_member = task.task_members.find_by(member_id: current_member.id)
    if task_member.present?
      if task_member.before_participation? || task_member.denial_by_owner? || task_member.denial_by_member? || task_member.leaving?
        task_member.approval_pending!
      end
    else
      task.task_members.create!(member_id: current_member.id, approval_status: "approval_pending")
    end
    # 通知
    task.create_activities(task, "request_join", current_member.id, task.owner_id)
    # タスク詳細ページに戻る
    redirect_to task_path(task)
  end

  def request_join_destroy
    task_member = TaskMember.find_by!(task_id: params[:id], member_id: current_member.id)
    task_member.denial_by_member!
    @task = Task.find(params[:id])
    # 通知
    @task.create_activities(@task, "request_join_destroy", current_member.id, @task.owner_id)
    # タスク詳細ページに戻る
    redirect_to  task_path(@task)
  end

  def applies
    @task = Task.find(params[:id])
    @task_members = @task.task_members.where(approval_status: "approval_pending")
  end

  def leaving
    TaskMember.find_by(task_id: params[:id], member_id: params[:member_id]).update(approval_status: "leaving")
    # 通知
    @task = Task.find(params[:id])
    @task.create_activities(@task, "leaving", @task.owner_id, params[:member_id])
    redirect_to  task_path(params[:id])
  end

  def approval_request
    # オーナーがログイン中のユーザーが、特定のタスクに参加する承認を行う
    TaskMember.find_by(task_id: params[:id], member_id: params[:member_id]).update(approval_status: "approval")
    # 通知
    @task = Task.find(params[:id])
    @task.create_activities(@task, "approval_request", @task.owner_id, params[:member_id])
    redirect_to applies_task_path(params[:id])
  end

  def non_approval_request
    # オーナーがログイン中のユーザーが、特定のタスクに参加する非承認を行う
    TaskMember.find_by(task_id: params[:id], member_id: params[:member_id]).update(approval_status: "denial_by_owner")
    # 通知
    @task = Task.find(params[:id])
    @task.create_activities(@task, "non_approval_request", @task.owner_id, params[:member_id])
    redirect_to applies_task_path(params[:id])
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
