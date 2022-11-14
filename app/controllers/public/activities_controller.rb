class Public::ActivitiesController < ApplicationController

  before_action :authenticate_member!

  def index
    @activities = Activity.where(visited_id: current_member.id).where.not(visitor_id: current_member.id).page(params[:page]).per(15)
    @activities = @activities.order(updated_at: :desc)
  end
end
