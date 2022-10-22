class Public::TaskFavoritesController < ApplicationController
  before_action :authenticate_user

  def create
    @task = Task.find(params[:task_id])
    current_member.task_favorites.create(task_id: params[:task_id])
  end

  def destroy
    task_favorite = current_member.task_favorites.find_by(task_id: params[:task_id])
    if task_favorite.present?
      task_favorite.destroy
    end
    @task = Task.find(params[:task_id])
  end
end

