class Public::NotificationsController < ApplicationController

  before_action :authenticate_member!

  def index
    @notifications = current_member.passive_notifications.page(params[:page]).per(20)
  end

  def destroy
    @notifications = current_member.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
