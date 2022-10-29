class Admin::MembersController < ApplicationController

  before_action :authenticate_admin!

  def index
    @members = Member.page(params[:page])
    @members = @members.order(updated_at: :desc)
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      flash[:notice] = "登録情報を変更しました。"
      redirect_to admin_member_path(@member)
    else
      flash[:notice] = "登録情報の変更に失敗しました。"
      render "edit"
    end

  end

  private

  def member_params
    params.require(:member).permit(:display_name, :user_name, :email, :is_deleted, :profile_image)
  end
end
