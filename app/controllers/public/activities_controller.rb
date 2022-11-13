class Public::ActivitiesController < ApplicationController

  before_action :authenticate_member!

  def index
    @activities = Activity.where(visited_id: current_member.id).where.not(visitor_id: current_member.id).page(params[:page]).per(15)
  end

  def destroy
    @activities = current_member.passive_activities.destroy_all
    redirect_to activities_path
  end
end
