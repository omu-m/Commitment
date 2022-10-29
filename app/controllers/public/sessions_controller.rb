# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController

  before_action :reject_member, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    mypage_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # ゲストログイン（閲覧用）
  def guest_sign_in
    member = Member.guest
    sign_in member
    redirect_to tasks_path
    flash[:notice] = "ゲストユーザーでログインしました。"
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.

  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:user_name])
  # end

  # 退会しているかを判断するメソッド
  def reject_member
    # (処理1) 入力された項目からアカウントを1件取得
    @member = Member.find_by(user_name: params[:member][:user_name])
    # アカウントを取得できなかった場合、このメソッドを終了する
    return if !@member
    # (処理2) 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    if @member.valid_password?(params[:member][:password]) && (@member.is_deleted == true)
      flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
      redirect_to new_member_registration_path
    else
      flash[:notice] = "再度項目を入力してください"
    end
  end
end
