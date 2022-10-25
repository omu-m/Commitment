class ApplicationController < ActionController::Base

  private

  def guest_user_sigend_in?
    member_signed_in? && (current_member.email == "guest@example.com")
  end

  def authenticate_user
    redirect_back(fallback_location: root_path) if guest_user_sigend_in?
  end

end