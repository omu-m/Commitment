class Public::FavoritesController < ApplicationController

  def create
    @subtask = Subtask.find(params[:subtask_id])
    current_member.favorites.create(subtask_id: params[:subtask_id])
  end

  def destroy
    favorite = current_member.favorites.find_by(subtask_id: params[:subtask_id])
    if favorite.present?
      favorite.destroy
    end
    @subtask = Subtask.find(params[:subtask_id])
  end
end
