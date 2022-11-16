class ApplicationController < ActionController::Base
  before_action :activities_checker

  def activities_checker
    unless current_member.nil?
      @activity_count = Activity.where(visited_id: current_member.id, checked: false).count
    end
  end

  private

  def guest_user_sigend_in?
    member_signed_in? && (current_member.email == "guest@example.com")
  end

  def authenticate_user
    redirect_back(fallback_location: root_path) if guest_user_sigend_in?
  end

end