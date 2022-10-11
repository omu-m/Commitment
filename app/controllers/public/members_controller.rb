class Public::MembersController < ApplicationController
  before_action :authenticate_member!

  def show
    @member = current_member

  end

  def edit

  end

  def unsubscribe
  end

  def withdrawal
    @member = Member.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @member.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:member).permit(:email, :display_name, :user_name)
  end
end
