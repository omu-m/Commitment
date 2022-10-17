class Public::FavoritesController < ApplicationController

  def create
    @subtask = Subtask.find(params[:subtask_id])
    @subtask.task_id = params[:task_id]
    @favorite = Favorite.new(member_id: current_member.id, subtask_id: @subtask.id)
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
