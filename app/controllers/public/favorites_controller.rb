class Public::FavoritesController < ApplicationController

  def create
    @subtask = Subtask.find(params[:subtask_id])
    @favorite = Favorite.new(subtask_id: @subtask.id)
    @favorite.member_id = current_member.id
    @subtask.save
    redirect_to request.referer
  end

  def destroy
    @subtask = Subtask.find(params[:subtask_id])
    @subtask = current_member.favorites.find_by(subtask_id: @subtask.id)
    subtask.destroy
    redirect_to request.referer
  end
end
