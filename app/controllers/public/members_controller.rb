class Public::MembersController < ApplicationController
  before_action :authenticate_member!

  def show
    @member = current_member

  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    if @member.update(member_params)
       flash[:notice] = "登録情報を変更しました。"
       redirect_to mypage_path
    else
       flash[:notice] = "登録情報の変更に失敗しました。"
       render "edit"
    end
  end

  def task_favorites
    @member = Member.find(params[:id])
    task_favorites = TaskFavorite.where(member_id: @member.id).pluck(:task_id)
    @task_favorite_tasks = Task.find(task_favorites)
  end

  def unsubscribe
  end

  def withdrawal
    @member = current_member
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @member.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました。"
    redirect_to root_path
  end

  private

  def member_params
    params.require(:member).permit(:email, :display_name, :user_name)
  end
end
