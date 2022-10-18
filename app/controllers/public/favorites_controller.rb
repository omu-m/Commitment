class Public::FavoritesController < ApplicationController

  def create
    current_member.favorites.create(subtask_id: params[:subtask_id])
    redirect_to request.referer
  end

  def destroy
    favorite = current_member.favorites.find_by(subtask_id: params[:subtask_id])
    if favorite.present?
      favorite.destroy
    end
    redirect_to request.referer
  end
end
