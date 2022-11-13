class Public::FavoritesController < ApplicationController

  def create
    @subtask = Subtask.find(params[:subtask_id])
    favorite = current_member.favorites.create(subtask_id: params[:subtask_id])
    subtask_id = favorite.subtask_id
    member = Subtask.find(params[:subtask_id])
    Association.create_notification_favotite!(current_member, member.member_id, favorite.id)
  end

  def destroy
    favorite = current_member.favorites.find_by(subtask_id: params[:subtask_id])
    notifications = Notification.where(association_id: favorite.id).where(action: "favorit")
    if favorite.present?
      notifications.destroy_all
      favorite.destroy
    end
    @subtask = Subtask.find(params[:subtask_id])
  end
end
