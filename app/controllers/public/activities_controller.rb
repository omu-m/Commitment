class Public::ActivitiesController < ApplicationController

  before_action :authenticate_member!
  before_action :get_activities

  def index
    @activities = @activities.where(checked: false).order(updated_at: :desc).page(params[:page]).per(15)
  end

  def checked
    @activities = @activities.where(checked: true).order(updated_at: :desc).page(params[:page]).per(15)
  end

  def update_all
    @activities = @activities.where(checked: false).order(updated_at: :desc).page(params[:page]).per(15)
    @activities.update_all(checked: true)
    redirect_to activities_path
  end

  private

  def get_activities
    @activities = Activity.where(visited_id: current_member.id).where.not(visitor_id: current_member.id)
  end
end
