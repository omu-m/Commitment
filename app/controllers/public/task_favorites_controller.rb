class Public::TaskFavouritesController < ApplicationController

  def create
    current_member.task_favorites.create(task_id: params[:task_id])
    redirect_to request.referer
  end

  def destroy
    task_favorite = current_member.task_favorites.find_by(task_id: params[:task_id])
    if task_favorite.present?
      task_favorite.destroy
    end
    redirect_to request.referer
  end
end

